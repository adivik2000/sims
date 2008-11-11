# == Schema Information
# Schema version: 20081111204313
#
# Table name: roles
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  district_id :integer
#  state_id    :integer
#  country_id  :integer
#  system      :boolean
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Role do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :system => false,
      :position => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    Role.create!(@valid_attributes.merge(:district_id=>1))
  end

  it 'should belong only to one of: district, state, country or system' do
    Role.new(@valid_attributes.merge(:district_id =>1, :state_id =>1)).should_not be_valid
    Role.new(@valid_attributes.merge(:district_id =>1, :system=>true)).should_not be_valid
    Role.new(@valid_attributes.merge(:state_id =>1, :country_id =>1)).should_not be_valid
    Role.new(@valid_attributes.merge(:district_id =>1, :state_id =>1)).should_not be_valid
    Role.new(@valid_attributes.merge(:country_id =>1, :system =>false)).should be_valid
    
  end
end
