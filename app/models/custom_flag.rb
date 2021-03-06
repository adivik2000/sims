# == Schema Information
# Schema version: 20101101011500
#
# Table name: flags
#
#  id         :integer(4)      not null, primary key
#  category   :string(255)
#  user_id    :integer(4)
#  student_id :integer(4)
#  reason     :text
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class CustomFlag < Flag
  validate :either_custom_or_ignore


  define_statistic :flags , :count => :all,:joins =>:student
  define_statistic :students_with_flags , :count => :all,  :select => 'distinct student_id',:joins => :student
  define_statistic :districts_with_flags, :count => :all, :select => 'distinct students.district_id', :joins => :student
  define_statistic :users_with_flags, :count => :all, :select => 'distinct user_id', :joins => :student

  def either_custom_or_ignore
    if IgnoreFlag.find_by_category_and_student_id(category, student_id)
      errors.add(:category, "Remove custom flag first.")
    end
  end
end
