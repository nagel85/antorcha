require 'spec_helper'

describe Organization do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :url => "value for url"
    }
  end

  it "should create a new instance given valid attributes" do
    Organization.create!(@valid_attributes)
  end
  
  it "should validate on title" do
    Organization.create()
    should have(1).error_on(:title)
  end
  
  describe "check polymorphic assosiations with roles" do
    before(:each) do
      @org = Factory.create(:organization)
    end
    
    it "should creat an role through fulfills" do    
      role = @org.roles.create(:title => "role1")
      role.should have(:no).error
    end
    
    it "should fail creating an role through fulfills" do
      role = @org.roles.create()
      role.should have(1).error_on(:title)
    end
  end
end