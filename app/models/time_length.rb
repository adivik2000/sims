# == Schema Information
# Schema version: 20090212222347
#
# Table name: time_lengths
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  days       :integer
#  created_at :datetime
#  updated_at :datetime
#

class TimeLength < ActiveRecord::Base
  begin
    TIMELENGTHS = TimeLength.find(:all)
  rescue
    puts "Table may not exist yet."
  end

  def after_create
    TimeLength.const_set("TIMELENGTHS",TimeLength.all)
  end
end
