require 'spec_helper'

describe "/steps/show.html.erb" do
  include StepsHelper
  before(:each) do
    assigns[:step] = @step = stub_model(Step,
      :title => "value for title"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
  end
end