require 'spec_helper'

describe "/transactions/index.html.erb" do
  include TransactionsHelper

  before(:each) do

    view_as_user :maintainer
    
    assigns[:transactions] = [
      stub_model(Transaction,
        :title => "value for title",
        :name => "value for name",
        :definition => mock_definition,
        :created_at => Time.now
      ),
      stub_model(Transaction,
        :title => "value for title",
        :name => "value for name",
        :definition => mock_definition,
        :created_at => Time.now
      )
    ]
    
    assigns[:search] = mock_search
    mock_search.stub :id => nil
    
    mock_search.stub :organization_ids => [1,2,3]
    
    mock_definition.stub(:title => 'My Definition')
    template.stub(:admin_signed_in? => true)
  end

  it "renders a list of transactions" do
    render
    response.should have_tag("ul li a", "value for title".to_s, 2)
  end
end
