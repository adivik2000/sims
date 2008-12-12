require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe District::SchoolsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_schools(stubs={})
    @mock_schools ||= mock_model(School, stubs)
  end
 
  before do
    district=mock_district
    controller.stub!(:current_district=>district)
    district.stub!(:schools=>School)
   end

 
  describe "responding to GET index" do
    it "should expose all district_schools as @schools" do
      School.should_receive(:find).with(:all).and_return([mock_schools])
      get :index
      assigns[:schools].should == [mock_schools]
    end

    describe "with mime type of xml" do
  
      it "should render all district_schools as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        School.should_receive(:find).with(:all).and_return(schools = mock("Array of School"))
        schools.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested schools as @schools" do
      School.should_receive(:find).with("37").and_return(mock_schools)
      get :show, :id => "37"
      assigns[:school].should equal(mock_schools)
    end
    
    describe "with mime type of xml" do

      it "should render the requested schools as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        School.should_receive(:find).with("37").and_return(mock_schools)
        mock_schools.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new schools as @schools" do
      School.should_receive(:build).and_return(mock_schools)
      get :new
      assigns[:school].should equal(mock_schools)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested schools as @schools" do
      School.should_receive(:find).with("37").and_return(mock_schools)
      get :edit, :id => "37"
      assigns[:school].should equal(mock_schools)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created schools as @schools" do
        School.should_receive(:build).with({'these' => 'params'}).and_return(mock_schools(:save => true))
        post :create, :schools => {:these => 'params'}
        assigns(:school).should equal(mock_schools)
      end

      it "should redirect to the created schools" do
        School.stub!(:build).and_return(mock_schools(:save => true))
        post :create, :schools => {}
        response.should redirect_to(district_school_url(mock_schools))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved schools as @schools" do
        School.stub!(:build).with({'these' => 'params'}).and_return(mock_schools(:save => false))
        post :create, :schools => {:these => 'params'}
        assigns(:school).should equal(mock_schools)
      end

      it "should re-render the 'new' template" do
        School.stub!(:build).and_return(mock_schools(:save => false))
        post :create, :schools => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested schools" do
        School.should_receive(:find).with("37").and_return(mock_schools)
        mock_schools.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :schools => {:these => 'params'}
      end

      it "should expose the requested schools as @schools" do
        School.stub!(:find).and_return(mock_schools(:update_attributes => true))
        put :update, :id => "1"
        assigns(:school).should equal(mock_schools)
      end

      it "should redirect to the schools" do
        School.stub!(:find).and_return(mock_schools(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(district_school_url(mock_schools))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested schools" do
        School.should_receive(:find).with("37").and_return(mock_schools)
        mock_schools.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :schools => {:these => 'params'}
      end

      it "should expose the schools as @schools" do
        School.stub!(:find).and_return(mock_schools(:update_attributes => false))
        put :update, :id => "1"
        assigns(:school).should equal(mock_schools)
      end

      it "should re-render the 'edit' template" do
        School.stub!(:find).and_return(mock_schools(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested schools" do
      School.should_receive(:find).with("37").and_return(mock_schools)
      mock_schools.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the district_schools list" do
      School.stub!(:find).and_return(mock_schools(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(district_schools_url)
    end

  end

end
