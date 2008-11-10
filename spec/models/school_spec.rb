require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe School do

  describe 'grades_by_user' do
    it 'should return all grades in school when user has access to 
    all students in the school and add a * when there is more than one' do
      school=School.create!
      user=mock_user
      special_group = mock_array
      user.should_receive('special_user_groups').and_return(special_group)
      school.enrollments= [Enrollment.new(:grade=>2),Enrollment.new(:grade=>1),Enrollment.new(:grade=>4),Enrollment.new(:grade=>3)]
      special_group.should_receive('all_students_in_school?').with(school).and_return(true)

      school.grades_by_user(user).should == ['*','1','2','3','4']

                                
    end
 
    it 'should not prepend * if there is only one' do
      school=School.create!
      school.enrollments.create(:grade=>'only')
      user=mock_user
      user.stub_association!(:special_user_groups, :all_students_in_school? =>  true)
      school.grades_by_user(user).should == ['only']

    end

    it 'should return subset of grades in the school where there is at least one student that the user has access to' do

      school=School.create!
      school.enrollments= [Enrollment.new(:grade=>2),Enrollment.new(:grade=>1),Enrollment.new(:grade=>4),Enrollment.new(:grade=>3)]
      user=mock_user
      user.stub_association!(:special_user_groups, :all_students_in_school? =>  false)

      %w{2 4}.each do |g|
        Enrollment.should_receive(:student_in_this_grade_belonging_to_user?).with(g,user).and_return(true)
      end

      %w{1 3}.each do |g|
         Enrollment.should_receive(:student_in_this_grade_belonging_to_user?).with(g,user).and_return(false)
      end



    school.grades_by_user(user).should == ['*','2','4']


    end

  end
end
