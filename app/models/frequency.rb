# == Schema Information
# Schema version: 20081208201532
#
# Table name: frequencies
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Frequency < ActiveRecord::Base
  FREQUENCIES=Frequency.find(:all)
end
