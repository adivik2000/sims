# == Schema Information
# Schema version: 20081208201532
#
# Table name: groups
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  school_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Group do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
    }
  end

  it "should create a new instance given valid attributes" do
    Group.create!(@valid_attributes)
  end

  it "shoulld return an array of users when members is called" do
    Group.members.should == []
    User.destroy_all
    Group.destroy_all
    
    g1=Group.create!(:title=>"Group 1")
    g2=Group.create!(:title=>"Group 2")
    g3=Group.create!(:title=>"Group 3")
    g4=Group.create!(:title=>"Group 4")
    district=Factory(:district)
    u1=Factory(:user, :district=>district)
    u2=Factory(:user, :district=>district)

    g1.users << [u1]
    g2.users << [u2]
#    g3.users << User.all

    Group.members.should == [u1,u2]
  

  end
  
end
