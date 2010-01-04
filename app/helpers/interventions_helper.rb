module InterventionsHelper

  def tiered_intervention_definition_select(intervention_definitions, include_blank=true, selected = nil)

    #current_district.lock_tier?
   if  current_district.lock_tier
     lock_tier = true unless  ( current_district.state_dpi_num == 3269  && intervention_definitions.present? && intervention_definitions.first.objective_definition.title == "Improved Attendance")
   end
   ret=%q{<select id="intervention_definition_id" class="fixed_width" onchange="$('spinnerdefinitions').show();form.onsubmit()" name="intervention_definition[id]">}
  
    ret += '<option value=""></option>' if include_blank
    c=intervention_definitions.group_by{|e| e.tier.to_s}
    selected = selected.id if selected.present?
    if lock_tier 
      d=c.keys.sort[0..(current_student.max_tier.position-1)]
    else
      d=c.keys.sort
    end
    ret << selected.to_s
    d.each do |group|
      ret << '<optgroup label ="' + group + '">'
      ret << options_from_collection_for_select(  c[group], :id, :title, :selected => selected) if c[group]
      ret << '</optgroup>'
    end
    ret << '</select>'
    ret  
  end
  


  def tiered_quicklist(quicklist_items)
    if quicklist_items.blank?
      concat("Quicklist is empty.")
    else
      form_for :quicklist_item,  :url => quicklist_interventions_path do |f|
        concat(f.label(:intervention_definition_id, "Intervention Quicklist "))
        concat('<select id="quicklist_item_intervention_definition_id" onchange="form.submit()" name="quicklist_item[intervention_definition_id]"')
        concat('<option value=""></option>')
        gqi=quicklist_items.group_by{|q| "#{q.objective_definition} : #{q.tier}"}
        gqi.each do |group,col|
          concat("<optgroup label='#{group}'>")
          concat(options_from_collection_for_select(col, :id, :title))
          concat("</optgroup>")
        end
        concat('</select>')
          
          

        #        concat(f.collection_select(:intervention_definition_id, quicklist_items, :id, :title ,{:prompt=>""},:onchange=>"submit()"))
             
        concat("<noscript>#{ f.submit "Pick from Quicklist"}</noscript>")

      end
    
    end

  end
end
