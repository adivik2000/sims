# == Schema Information
# Schema version: 20081111204313
#
# Table name: student_comments
#
#  id         :integer         not null, primary key
#  student_id :integer
#  user_id    :integer
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class StudentComment < ActiveRecord::Base
  belongs_to :student
  belongs_to :user
  validates_presence_of :body
end
