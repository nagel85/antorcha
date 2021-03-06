class Role < Resource
  #validates_presence_of :title
  #validates_uniqueness_of :title, :scope => [:definition_id]
  
  #has_many :fulfills
  #has_many :organizations, :through => :fulfills
  belongs_to :definition
  
  has_many :permissions

  def title_with_definition
    return title unless definition
    "#{title} (van #{definition.title})"
  end

end
