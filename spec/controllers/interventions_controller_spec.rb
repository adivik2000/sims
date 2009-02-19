require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  before :each do
    @student = mock_student
    @intervention = mock_intervention(:student => @student, :comments => [])
    @interventions = [@intervention]
    @interventions.should_receive(:find_by_id).with(@intervention.id.to_s).any_number_of_times.and_return(@intervention)
    @student.should_receive(:interventions).any_number_of_times.and_return(@interventions)
    controller.should_receive(:current_student).any_number_of_times.and_return(@student)
    # build_from_session_and_params and populate_dropdowns are unit tested
    controller.should_receive(:build_from_session_and_params).any_number_of_times.and_return(@intervention)
  end

  describe "responding to GET show" do
    it "should expose the requested intervention as @intervention" do
      get :show, :id => @intervention.id
      assigns[:intervention].should equal(@intervention)
    end

    describe "with mime type of xml" do
      it "should render the requested intervention as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @intervention.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => @intervention.id
        response.body.should == "generated XML"
      end
    end
  end

  describe "responding to GET new" do
    before do
      controller.stub_association!(:current_school, :quicklist_items=>[])
      controller.should_receive(:populate_goals)
    end

    it "should call populate_goals" do
      get :new
      response.should be_success
    end

    it "should assign a @custom_intervention instance variable if the custom intervention param is there" do
      get :new, :custom_intervention => true
      response.should be_success
      flash[:custom_intervention].should == true
    end
  end

  describe "responding to GET edit" do
    it "should expose the requested intervention as @intervention" do
      get :edit, :id => @intervention.id
      assigns[:intervention].should equal(@intervention)
    end
  end

  describe "responding to POST create" do
    before do
      comments = []
      comments.should_receive(:build).and_return('some comment')
      @intervention.should_receive(:comments).and_return(comments)
    end

    describe "with valid params" do
      it "should expose a newly created intervention as @intervention" do
        @intervention.should_receive(:save).and_return(true)
        @intervention.should_receive(:autoassign_message).and_return('')
        post :create, :intervention => {:these => 'params'}
        assigns(:intervention).should equal(@intervention)
      end

      it "should redirect to the student profile" do
        @intervention.should_receive(:save).and_return(true)
        @intervention.should_receive(:autoassign_message).and_return('')
        post :create, :intervention => {}
        response.should redirect_to(student_url(@student))
      end
    end
    
    describe "with invalid params" do
      it "should expose a newly created but unsaved intervention as @intervention" do
        @intervention.should_receive(:save).and_return(false)
        @intervention.should_receive(:intervention_definition_id).and_return(1)
        post :create, :intervention => {:these => 'params'}
        assigns(:intervention).should equal(@intervention)
      end

      it "should re-render the 'new' template" do
        @intervention.should_receive(:save).and_return(false)
        @intervention.should_receive(:intervention_definition_id).and_return(1)
        post :create, :intervention => {}
        response.should render_template('new')
      end
    end
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do
      it "should update the requested intervention" do
        @intervention.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => @intervention.id, :intervention => {:these => 'params'}
      end

      it "should expose the requested intervention as @intervention" do
        @intervention.should_receive(:update_attributes).and_return(true)
        put :update, :id => @intervention.id
        assigns(:intervention).should equal(@intervention)
      end

      it "should redirect to the intervention" do
        @intervention.should_receive(:update_attributes).and_return(true)
        put :update, :id => @intervention.id
        response.should redirect_to(student_url(@student))
      end
    end

    describe "with invalid params" do
      it "should update the requested intervention" do
        @intervention.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => @intervention.id, :intervention => {:these => 'params'}
      end

      it "should expose the intervention as @intervention" do
        @intervention.should_receive(:update_attributes).and_return(false)
        put :update, :id => @intervention.id
        assigns(:intervention).should equal(@intervention)
      end

      it "should re-render the 'edit' template" do
        @intervention.should_receive(:update_attributes).and_return(false)
        put :update, :id => @intervention.id
        response.should render_template('edit')
      end
    end
  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested intervention" do
      @intervention.should_receive(:destroy)
      delete :destroy, :id => @intervention.id
    end
  
    it "should redirect to the interventions list" do
      @intervention.should_receive(:destroy)
      delete :destroy, :id => @intervention.id
      response.should redirect_to(student_url(@student))
    end
  end

  describe "responding to UPDATE end" do
    it "should end the requested intervention" do
      controller.should_receive(:current_user).and_return(mock_model(User,:id=>1))
      @intervention.should_receive(:end).with(1)
      put :end, :id => @intervention.id
    end
  
    it "should redirect to the interventions list" do
      controller.should_receive(:current_user).and_return(mock_model(User, :id => 1))
      @intervention.should_receive(:end).with(1)
      put :end, :id => @intervention.id
      response.should redirect_to(student_url(@student))
    end
  end
end