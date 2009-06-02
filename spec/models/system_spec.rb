require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe System do
  it 'should have news which is an alias for NewsItem.system' do
    System.news.should ==(NewsItem.system)
  end

  it 'shoudl have roles which are equivalent to Roles.system' do
    System.roles.should ==(Role.system)

  end

  it 'should have admin district' do
    f=Factory(:country,:admin=>true)
    System.admin_district.should == f.admin_district

  end

end
