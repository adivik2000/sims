require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LoginController do
  before(:each) do
    controller.should_not_receive(:authenticate)
  end



 def mock_user(stubs={})
   @mock_user ||= mock_model(User, stubs)
 end

  describe "responding to GET index" do

    it "should call the login method and render the login template" do
      controller.should_receive(:login).and_return(true)
      get :index
      response.should render_template('login')
    end

  end

  describe "responding to GET login" do
    it "should be successful" do
      get :login
      assert session[:user_id] == nil
      response.should be_success
    end

    
  end

  describe "responding to POST login with valid credentials" do
    it "should be successful" do
      user=mock_user(:new_record=>false,:id=>999)
      User.should_receive(:authenticate).with('user','pass').and_return(user)
      post :login ,:username=>'user',:password=>'pass'
      session[:user_id].should == 999
      response.should redirect_to("/")
    end
  
  end

  describe "responding to POST login with invalid credentials" do
     it "should render the login" do
      User.should_receive(:authenticate).and_return(false)
      post :login
      session[:user_id].should == nil
      flash[:notice].should == "Authentication Failure"
      response.should redirect_to("/")
    end
  
  end

  describe "responding to GET logout" do
     it "should reset the session and redirect to root" do
       controller.should_receive(:reset_session)
       get :logout
       flash[:notice].should == " Logged Out"
       response.should redirect_to("/")

    end
  
  end



end
