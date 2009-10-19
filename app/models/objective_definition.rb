# == Schema Information
# Schema version: 20090623023153
#
# Table name: objective_definitions
#
#  id                 :integer(4)      not null, primary key
#  title              :string(255)
#  description        :text
#  goal_definition_id :integer(4)
#  position           :integer(4)
#  disabled           :boolean(1)
#  created_at         :datetime
#  updated_at         :datetime
#  deleted_at         :datetime
#  copied_at          :datetime
#  copied_from        :integer(4)
#

class ObjectiveDefinition < ActiveRecord::Base
  include LinkAndAttachmentAssets
  belongs_to :goal_definition
  has_many :intervention_clusters, :order =>:position, :dependent=> :destroy
  
  validates_presence_of :title, :description
  validates_uniqueness_of :description, :scope => [:goal_definition_id,:title, :deleted_at]
  acts_as_list :scope => :goal_definition_id
  is_paranoid
  include DeepClone
  acts_as_reportable if defined? Ruport

  def disable!
    intervention_clusters.each(&:disable!)
    update_attribute(:disabled,true)
  end

  def to_s
    title
  end

 private

  def deep_clone_parent_field
    'goal_definition_id'
  end

  def deep_clone_children
    %w{intervention_clusters}
  end


end
