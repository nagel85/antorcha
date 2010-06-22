class Instruction < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :name, :if => :title
  validates_uniqueness_of :name

  belongs_to :procedure
  has_many :messages

  named_scope :to_start_with, :conditions => {:start => true}

  before_validation :parameterize_title_for_name

  def parameterize_title_for_name
    self.name = title.parameterize if title
  end

end