# == Schema Information
# Schema version: 20090524185436
#
# Table name: roles
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  district_id        :integer
#  position           :integer
#  created_at         :datetime
#  updated_at         :datetime
#  asset_file_name    :string(255)
#  asset_content_type :string(255)
#  asset_file_size    :integer
#  asset_updated_at   :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Role do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :position => "1",
      :district_id =>1
    }
  end

  it "should create a new instance given valid attributes" do
    Role.create!(@valid_attributes.merge(:district_id=>1))
  end

        

  describe 'has_controller_and_action_group?' do
    it 'should return nothing when there are no matching controllers and something when there is' do
      r= Role.create!(@valid_attributes.merge(:district_id=>1))
      r.rights.create!(:controller=>'students',:read_access=>true)
      Role.has_controller_and_action_group?('puppies', 'read_access').should == false
      Role.has_controller_and_action_group?('students', 'read_access').should == true
      Role.has_controller_and_action_group?('students', 'write_access').should == false
      Role.has_controller_and_action_group?('students', 'unknown').should == false
    end
      

  end
end
