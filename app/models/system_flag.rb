# == Schema Information
# Schema version: 20090623023153
#
# Table name: flags
#
#  id          :integer(4)      not null, primary key
#  category    :string(255)
#  user_id     :integer(4)
#  district_id :integer(4)
#  student_id  :integer(4)
#  reason      :text
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class SystemFlag < Flag
  CSV_HEADERS = [:student_id_district, :category, :reason]

  validates_uniqueness_of :category, :scope => :student_id

  def summary
    "#{reason} on #{created_at}"
  end
end
