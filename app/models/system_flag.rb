# == Schema Information
# Schema version: 20081223233819
#
# Table name: flags
#
#  id          :integer         not null, primary key
#  category    :string(255)
#  user_id     :integer
#  district_id :integer
#  student_id  :integer
#  reason      :text
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class SystemFlag < Flag
  validates_uniqueness_of :category, :scope=>:student_id
end
