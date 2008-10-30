require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::ProbeAssignmentsController do
  it_should_behave_like "an authenticated controller"

  def mock_intervention_probe_assignments(stubs={})
    @mock_intervention_probe_assignments ||= mock_model(InterventionProbeAssignments, stubs)
  end

  def params
    {:intervention_id=>1}
  end
  
  before do
    @student=mock_student
    @intervention=mock_intervention
    @student.stub_association!(:interventions,:find=>@intervention)
    controller.should_receive(:current_student).and_return(@student)
  end

  it 'should load_intervention' do
   controller.should_receive(:params).and_return(params)
   controller.send(:load_intervention).should ==(@intervention)
  end

  describe "responding to GET index" do

    it "should expose all intervention_probe_assignment as @intervention_probe_assignments" do
      @intervention.stub_association!(:intervention_probe_assignments,:prepare_all=>[1,2,3])
      get :index, :intervention_id=>1
      assigns[:intervention_probe_assignments].should == [1,2,3]
      assigns[:intervention].should == @intervention
      response.should be_success
    end
  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created intervention_probe_assignments as @intervention_probe_assignments" do

        pending
        InterventionProbeAssignments.should_receive(:new).with({'these' => 'params'}).and_return(mock_intervention_probe_assignments(:save => true))
        post :create, :intervention_probe_assignments => {:these => 'params'}
        assigns(:intervention_probe_assignments).should equal(mock_intervention_probe_assignments)
      end

      it "should redirect to the created intervention_probe_assignments" do
        pending
        InterventionProbeAssignments.stub!(:new).and_return(mock_intervention_probe_assignments(:save => true))
        post :create, :intervention_probe_assignments => {}
        response.should redirect_to(intervention_probe_assignment_url(mock_intervention_probe_assignments))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved intervention_probe_assignments as @intervention_probe_assignments" do
        pending
        InterventionProbeAssignments.stub!(:new).with({'these' => 'params'}).and_return(mock_intervention_probe_assignments(:save => false))
        post :create, :intervention_probe_assignments => {:these => 'params'}
        assigns(:intervention_probe_assignments).should equal(mock_intervention_probe_assignments)
      end

      it "should re-render the 'new' template" do
        pending
        InterventionProbeAssignments.stub!(:new).and_return(mock_intervention_probe_assignments(:save => false))
        post :create, :intervention_probe_assignments => {}
        response.should render_template('new')
      end
      
    end
    
  end

end