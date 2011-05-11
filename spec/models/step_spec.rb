require 'spec_helper'

describe Step do

  subject {
    Step.new :id => 37
  }

  describe "step effects" do
    it "should get the effects from a step from the subcollection effects on olympus" do
      Step.should_receive(:find).with(:all, hash_including(:from => "/steps/37/effects.xml"))
      subject.effects
    end

    it "should send query with the user roles as parameter" do
      mock_user.stub :castables => mock_castables
      mock_castable.stub :role_id => 1
      Step.should_receive(:find).with(:all, hash_including(:params => { :permitted_for_roles => [1,1]}))
      subject.effects :user => mock_user
    end
  end
  
  describe "starting steps" do
    it "should send query to the correct url" do
      Step.should_receive(:find).with(:all, hash_including(:from => :start))

      Step.starting_steps
    end

    it "should send query with the user roles as parameter" do
      mock_user.stub :castables => mock_castables
      mock_castable.stub :role_id => 1
      Step.should_receive(:find).with(:all, hash_including(:params => { :permitted_for_roles => [1,1]}))
      Step.starting_steps  :user => mock_user
    end

    
    it "should return the defined fixtures" do
      Step.starting_steps.collect(&:title).sort.should include("Melding aan VIS2", "Informatieverzoek (gegevens actueel houden)")
    end
  end

  describe ".find_by_recipient_role_ids" do
    it "should delegate this to olympus" do
      example_role_ids = [1,2]
      
      Step.should_receive(:all).with(:recipient_role_ids => example_role_ids).and_return(mock_steps)
      Step.find_by_recipient_role_ids(example_role_ids).should == mock_steps
    end
  end
  
  describe ".find_ids_by_recipient_role_ids used for filtering the messages index on recipient users" do
    it "should delegate this to olympus" do
      example_role_ids = [1,2]
      
      Step.should_receive(:find_by_recipient_role_ids).with(example_role_ids).and_return(mock_steps)
      Step.find_ids_by_recipient_role_ids(example_role_ids).should == mock_steps.collect(&:id)
    end
  end

  describe "destination organizations" do
    it "should send query to the correct url" do
      Organization.should_receive(:find).with(:all, :from => "/steps/37/destination_organizations.xml")
      subject.destination_organizations
    end
    
  end

end
