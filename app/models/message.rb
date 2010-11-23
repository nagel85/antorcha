require 'message_serialization'

class Message < ActiveRecord::Base
  include MessageSerialization
  include CrossAssociatedModel

  validates_presence_of :title, :on => :update
  validates_presence_of :step
  validates_presence_of :transaction
  validates_presence_of :username

  validates_presence_of :organization, :if => :incoming?
  validates_presence_of :sent_at, :if => :delivered?
  validates_presence_of :organization, :if => :incoming?

  belongs_to :transaction
  belongs_to_resource :organization
  cache_and_delegate :title, :to => :organization, :prefix => true, :allow_nil => true

  belongs_to_resource :step
  belongs_to_resource :organization

  flagstamp :sent, :shown
  antonym :draft => :sent
  antonym :outgoing => :incoming
  
  belongs_to :request, :class_name => 'Message'
  has_many :replies, :class_name => 'Message', :foreign_key => 'request_id'

  has_many :deliveries
  #has_many :delivery_organizations, :through => :deliveries, :source => :organization

  default_scope :order => 'messages.created_at DESC'
  
  named_scope :inbox, :conditions => {:incoming => true}
  named_scope :outbox, :conditions => {:incoming => false}
  named_scope :read, :conditions => "shown_at IS NOT NULL"
  named_scope :unread, :conditions => "shown_at IS NULL"
  named_scope :with_definition, lambda{|definition| {:joins => :step, :conditions => { :steps => {:definition_id => definition}}} }
  named_scope :expired, lambda { {:joins => :transaction, :conditions => ["transactions.expired_at < ?", Time.now]} }
  named_scope :unexpired, lambda { {:joins => :transaction, :conditions => ["transactions.expired_at > ? OR transactions.expired_at IS NULL", Time.now]} }
  named_scope :cancelled, :joins => :transaction, :conditions => "transactions.cancelled_at is NOT NULL"
  named_scope :notcancelled, :joins => :transaction, :conditions => "transactions.cancelled_at is NULL"

  named_scope :steps, lambda { |steps| {:conditions => { :step_id => steps } } }
  
  named_scope :user_id, lambda {|user_id|
    user = User.find user_id
    relevant_step_ids = Step.find_ids_by_recipient_role_ids user.role_ids
    { :conditions => { :step_id => relevant_step_ids } }
  }
  
  delegate :definition, :to => :step
  delegate :destination_url, :to => :step

  delegate :cancelled?, :to => :transaction
  delegate :expired?, :to => :transaction  
  delegate :test?, :to => :definition

  after_create :format_title
  after_create :notify_a2s
  
  before_validation :take_over_transaction_from_request
  
  def updatable?
    outgoing? and draft? and not cancelled?
  end
  
  def notify_a2s
    if Notifier.count > 0
      notifier = Notifier.first
      notifier.queue_notification
    end
  end
  
  def self.show message_id
    message = find(message_id)
    message.shown!
    message
  end
  
  def expired
    expired?
  end
  
  def unread
    shown_at.nil?
  end
  
  def cancelled
    cancelled? == :cancelled ? true : false
  end
  
  def replyable?
    incoming? and step.replyable? and not cancelled?
  end
  
  def cancellable?
    outgoing? and step.start? and not cancelled?
  end

  def effect_steps options = {}
    step.effects options
  end
  
  delegate :destination_organizations, :to => :step

  def status
    status ||= :incoming if incoming?
    status ||= :delivered if delivered?
    status ||= :sent if sent?
    status ||= :draft
    status
  end

  # def statuses
  #   [ delivered?, expired?].compact
  # end

  def delivered_at
    delivered_at = deliveries.maximum :confirmed_at
    delivered_at.in_time_zone if delivered_at
  end

  def delivered?
    not (deliveries.count == 0 or deliveries.exists? :confirmed_at => nil)
  end

  def build_reply user, params
    @message = replies.build(params)
    @message.username = user.username
    @message
  end

  def send_deliveries
    if self.step.single_response
      logger.info "*** Sending single response message to an organization: #{request.organization_id} ***"
      deliveries << deliveries.build(:organization => Organization.find(request.organization_id))
    else
      logger.info "*** Sending multiple response messages to different organizations ***"
      destination_organizations.each do |org|
        deliveries << deliveries.build(:organization => org)
      end
    end
    
    sent!
  end
  
  def send_deliveries_and_ourself
    organizations = destination_organizations << Organization.ourself   
    organizations.each do |org|
      deliveries << deliveries.build(:organization => org)
    end
    sent!
  end



private
  def format_title
    update_attributes :title => "#{step.title} \##{id}" if title.blank?
  end

  def take_over_transaction_from_request
    self.transaction = request.transaction if transaction.blank? and request
  end

end

