# == Schema Information
# Schema version: 20090623023153
#
# Table name: intervention_clusters
#
#  id                      :integer(4)      not null, primary key
#  title                   :string(255)
#  description             :text
#  objective_definition_id :integer(4)
#  position                :integer(4)
#  disabled                :boolean(1)
#  created_at              :datetime
#  updated_at              :datetime
#  deleted_at              :datetime
#  copied_at               :datetime
#  copied_from             :integer(4)
#


#Also known as category
class InterventionCluster < ActiveRecord::Base
  belongs_to :objective_definition
  has_many :intervention_definitions, :order =>'disabled, custom, position', :dependent => :destroy

  delegate :goal_definition, :to => :objective_definition

  validates_presence_of :title
  validates_uniqueness_of :description, :scope => [:objective_definition_id, :title, :deleted_at]

  acts_as_reportable if defined? Ruport
  acts_as_list :scope=>:objective_definition
  is_paranoid
  include DeepClone
  define_statistic :count , :count => :all
  define_statistic :distinct , :count => :all,  :select => 'distinct title'
  define_calculated_statistic :districts_with_changes do
    find(:all,:group => "#{self.name.tableize}.title", :having => "count(#{self.name.tableize}.title)=1",:select =>'distinct district_id', :joins => {:objective_definition=>:goal_definition}).length
  end



  def disable!
    intervention_definitions.each(&:disable!)
    update_attribute(:disabled,true)
  end

  def summary_with_parent_tables
    "#{self.goal_definition.title}/#{self.objective_definition.title}/#{self.title}"
  end

  def to_s
    title
  end

  private
  def deep_clone_parent_field
    'objective_definition_id'
  end

  def deep_clone_children
    %w{intervention_definitions}
  end


end
