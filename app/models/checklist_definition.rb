class ChecklistDefinition < ActiveRecord::Base
  belongs_to :district
  has_many :question_definitions, :dependent => :destroy, :order => "rank ASC"
  has_many :element_definitions, :through =>:question_definitions
  has_many :checklists

  validates_presence_of :directions, :text
  acts_as_reportable if defined? Ruport

  def self.active_checklist_definition
    find_by_active(true)  || ChecklistDefinition.new
  end

  def self.new_from_existing(checklist_definition)
    new_checklist_definition = ChecklistDefinition.new(checklist_definition.attributes.merge(:active => false))
    checklist_definition.question_definitions.each do |question_definition|
      new_checklist_definition.question_definitions << QuestionDefinition.new_from_existing(question_definition)
    end
    checklist_definition.minimum_scores.each do |minimum_score|
      new_checklist_definition.minimum_scores << MinimumScore.new_from_existing(minimum_score)
    end
    new_checklist_definition
  end

  def save_all!
    save! and
    question_definitions.each(&:save!) and
    element_definitions.each(&:save!) and
    answer_definitions.each(&:save!)
  end

  def answer_definitions
    element_definitions.collect(&:answer_definitions).flatten
  end


  def answer_definitions2
    @answer_definitions||=AnswerDefinition.find(:all,
    :include=>[:element_definition=>{:question_definition=>:checklist_definition}],
    :joins=>"and question_definitions.checklist_definition_id=#{id}")
  end
  protected

  def before_save
    if active?
      district.checklist_definitions.active_checklist_definition.update_attribute(:active, false)
    end
  end

end
