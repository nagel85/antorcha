require 'spec_helper'

describe Message do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :body => "value for body",
      :incoming => false      
    }
  end

  it "should create a new instance given valid attributes" do
    Message.create!(@valid_attributes)
  end
end
