require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::ProbeAssignmentsController do
  it_should_behave_like "an authorized controller"
  describe "route generation" do
    it "should map #index" do
      pending
      route_for(:controller => "intervention_probe_assignments", :action => "index").should == "/intervention_probe_assignments"
    end
  
 end

  describe "route recognition" do
    it "should generate params for #index" do
      pending
      params_from(:get, "/intervention_probe_assignments").should == {:controller => "intervention_probe_assignments", :action => "index"}
    end
  
    it "should generate params for #create" do
      pending
      params_from(:post, "/intervention_probe_assignments").should == {:controller => "intervention_probe_assignments", :action => "create"}
    end
  end
  
end
