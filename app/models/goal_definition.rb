# == Schema Information
# Schema version: 20090623023153
#
# Table name: goal_definitions
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  description :text
#  district_id :integer(4)
#  position    :integer(4)
#  disabled    :boolean(1)
#  created_at  :datetime
#  updated_at  :datetime
#  deleted_at  :datetime
#  copied_at   :datetime
#  copied_from :integer(4)
#

class GoalDefinition < ActiveRecord::Base
  belongs_to :district
  has_many :objective_definitions, :order =>:position, :dependent => :destroy do
    def build_with_new_asset
      x=build
      x.assets.build
      x
    end
  end
  validates_uniqueness_of :description, :scope=>[:district_id,:title, :deleted_at]

  validates_presence_of :title, :description
  acts_as_list :scope=>:district_id
  is_paranoid
  include DeepClone

  def disable!
    objective_definitions.each(&:disable!)
    update_attribute(:disabled,true)
  end

  def to_s
    title
  end

  private
  def deep_clone_parent_field
    'district_id'
  end

  def deep_clone_children
    %w{objective_definitions}
  end

  
end
