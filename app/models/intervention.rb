class Intervention < ActiveRecord::Base
  belongs_to :user
  belongs_to :student
  belongs_to :intervention_definition
  belongs_to :frequency
  belongs_to :time_length
  belongs_to :ended_by, :class_name =>"User"

  has_many :intervention_probe_assignments do 
    def prepare_all(passed_params={})
      ipas=find(:all)
      prepared=[]
      proxy_owner.intervention_definition.recommended_monitors.each do |rec_mon|
        if d=ipas.detect{|ipa| ipa.probe_definition_id== rec_mon.probe_definition_id}
        else
          d= proxy_owner.intervention_probe_assignments.build(:probe_definition_id=>rec_mon.probe_definition_id)
        end
      
        if passed_params.respond_to?(:values)
          params=passed_params.values
        else
          params=passed_params
        end
        if p=params.detect{|param_ipa|  !param_ipa.nil? and
          d.probe_definition_id == param_ipa["probe_definition_id"].to_i}
          d.attributes=p
          d.enabled=p[:enabled]
        end
        prepared << d
      end
      prepared
    end
  end

  validates_numericality_of :time_length_number, :frequency_multiplier
  

  after_create :create_other_students
  attr_accessor :selected_ids, :apply_to_all


  named_scope :active,:conditions=>{:active=>true}
  named_scope :inactive,:conditions=>{:active=>false}
  
  def self.build_and_initialize(*args)
    int=self.new(*args)
    int.start_date ||=Time.now
    if int.intervention_definition
      int.frequency ||= int.intervention_definition.frequency
      int.frequency_multiplier ||= int.intervention_definition.frequency_multiplier
      int.time_length ||= int.intervention_definition.time_length
      int.time_length_number ||= int.intervention_definition.time_length_num
    end
    int.time_length ||=TimeLength::TIMELENGTHS.first
    int.time_length_number ||= 1
    int.end_date ||= (int.start_date + (int.time_length_number*int.time_length.days).days)
    int.selected_ids=nil if int.selected_ids.size == 1
    
    int
  end



  def title
    intervention_definition.title
  end

  def goal_definition
    objective_definition.goal_definition
  end

  def objective_definition
    intervention_cluster.objective_definition
  end

  def intervention_cluster
    intervention_definition.intervention_cluster
  end

  def end(ended_by)
    self.ended_by_id=ended_by
    self.active=false
    self.ended_at=Date.today
    self.save!
  end



  protected
  def create_other_students
    #TODO tests
    #make sure it does nothing when apply_to_all if false
    #make sure it doesn't create double interventions for the selected student
    #make sure it creates interventions for each student
    if self.apply_to_all =="1"
      student_ids=self.selected_ids
      student_ids.delete(self.student_id.to_s)
      student_ids.each do |student_id|
        Intervention.create!(self.attributes.merge(:student_id=>student_id,:apply_to_all=>false))
      end
    end
    true

  end






end
