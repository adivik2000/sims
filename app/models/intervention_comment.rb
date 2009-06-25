# == Schema Information
# Schema version: 20090623023153
#
# Table name: intervention_comments
#
#  id              :integer(4)      not null, primary key
#  intervention_id :integer(4)
#  comment         :text
#  user_id         :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

class InterventionComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :intervention
  validates_presence_of :comment
end
