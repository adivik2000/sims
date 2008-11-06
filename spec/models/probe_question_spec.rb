require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProbeQuestion do
  before(:each) do
    @valid_attributes = {
      :number => "1",
      :operator => "value for operator",
      :question_text => "value for question_text",
      :question_code => "value for question_code",
      :first_digit => "1",
      :second_digit => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    ProbeQuestion.create!(@valid_attributes)
  end
end
