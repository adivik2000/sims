# Interventions report for system interventions (via builder) found in the menu
Ruport::Formatter::Template.create(:standard) do |format|
  format.page = { :layout => :landscape }
  format.text ={ :font_size => 10 }
end

class StatewideProgressMonitorSummaryReport < DefaultReport 
  stage :header, :body
  load_html_csv_text


  def setup
    self.data = StatewideProgressMonitorSummary.new(options)
  end

  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => StatewideProgressMonitorSummaryReport
    build :header do
      pad_bottom(10) do
      end
    end


    build :body do
      pdf_writer.start_page_numbering(350, 10, 8, :center, 'Page: <PAGENUM>')
      pdf_writer.font_size = 6
      #757
      table_format = {
        :column_options => {
          'Title' => {:width => 125},
          'Description' => {:width => 125},
          'Min Score' => {:width => 75},
          'Max Score' => {:width => 75},
          'Interventions' => {:width => 150},
          'Districts' => {:width => 100},
          'Scores' => {:width => 100}
      }}

      render_table data.to_table, :table_format =>  {}     , :formatter => pdf_writer
    end
  end
end


class StatewideProgressMonitorSummary

  def initialize(options = {})
  end

  def to_table
    return unless defined? Ruport

    #group concat works well!
    eee= ProbeDefinition.connection.send(:select, 
    ProbeDefinition.send( :construct_finder_sql,{
     :group=>"probe_definitions.title", 
     :select => "probe_definitions.title as Title, probe_definitions.minimum_score as 'Min Score', probe_definitions.maximum_score as 'Max Score',probe_definitions.description as Description, 
      group_concat(distinct intervention_definitions.title separator ', ' ) as Interventions,
     count(distinct probe_definitions.district_id) as 'Districts' ,
     count(distinct probes.id) as 'Scores'
     ",
#     count(interventions.id) as count_of_interventions,
     :joins => "
    left outer join recommended_monitors on recommended_monitors.probe_definition_id = probe_definitions.id
    left join intervention_definitions on recommended_monitors.probe_definition_id = intervention_definitions.id
    left outer join intervention_probe_assignments on probe_definitions.id = intervention_probe_assignments.probe_definition_id
    left outer join probes on probes.intervention_probe_assignment_id = intervention_probe_assignments.id
    
    ", :order => "Title",
    :conditions => "probe_definitions.active=true and probe_definitions.custom=false"
                                                          }))
    t=Table :data => eee, :column_names => eee.first.keys
    t.reorder 'Title','Description', 'Min Score', 'Max Score', 'Interventions','Districts', 'Scores'
  end

  def to_grouping
    if @group.present?
      return @group
    else
      
      @table ||= to_table
    end
  end
end
