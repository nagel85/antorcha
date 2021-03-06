require 'spec_helper'

describe ReceptionsController do

  before(:each) do    
    turn_of_devise_and_cancan_because_this_is_specced_in_the_ability_spec
  end
  
  specify { should have_devise_before_filter }

  def mock_reception(stubs={})
    @mock_reception ||= mock_model(Reception, stubs)
  end

  describe "GET index" do
    it "assigns all receptions as @receptions" do
      Reception.stub(:find).with(:all).and_return([mock_reception])
      get :index
      assigns[:receptions].should == [mock_reception]
    end
  end

  describe "GET show" do
    it "assigns the requested reception as @reception" do
      Reception.stub(:find).with("37").and_return(mock_reception)
      get :show, :id => "37"
      assigns[:reception].should equal(mock_reception)
    end
  end

  describe "POST create" do
    before(:each) do
      Reception.stub(:new).and_return(mock_reception)
      mock_reception.stub :organization_id=
      mock_reception.stub :delivery_id=
      mock_reception.stub :certificate=
      mock_reception.stub :content=
    end

    def post_create
      post :create, \
        :delivery => delivery_params,
        :organization_id => mock_organization.to_param
    end
    
    def delivery_params
      { :id => mock_delivery.to_param, :message => 'CONTENT' }
    end
    
    describe "with valid params" do
      before(:each) do
        mock_reception.stub :save => true
      end
      
      it "assigns a newly created reception as @reception" do
        post_create
        assigns[:reception].should equal(mock_reception)
      end

      it "assigns the delivery hash to @reception.content" do
        mock_reception.should_receive(:content=).with('CONTENT')
        post_create
      end

      it "assigns the organization_id to @reception.organization_id" do
        mock_reception.should_receive(:organization_id=).with(mock_organization.to_param)
        post_create
      end

      it "assigns the delivery_id to @reception.delivery_id" do
        mock_reception.should_receive(:delivery_id=).with(mock_delivery.to_param)
        post_create
      end
      
      describe "in production mode" do
        before(:each) do
          Rails.env.stub :production? => true
          request.stub :ssl? => true
        end

        it "assigns the certificate from request.headers[SSL_CLIENT_CERT] to @reception.certificate" do
          request.env['SSL_CLIENT_CERT'] = 'CERTIFICATE'
          mock_reception.should_receive(:certificate=).with('CERTIFICATE')
          post_create
        end
      end

      describe "in development mode" do
        it "assigns a dummy certificate to @reception.certificate" do
          mock_reception.should_receive(:certificate=).with('NO CERTIFICATE')
          post_create
        end
      end

      it "redirects to the created reception" do
        post_create
        response.should redirect_to(reception_url(mock_reception))
      end
    end

    describe "with invalid params" do
      before(:each) do
        mock_reception.stub :save => false
      end
      
      it "assigns a newly created but unsaved reception as @reception" do
        post_create
        assigns[:reception].should equal(mock_reception)
      end

      it "re-renders the 'new' template" do
        post_create
        response.should render_template('new')
      end
    end
  end

end
