# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'
require File.expand_path(File.dirname(__FILE__) + '/mock_helper')

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  # 
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
  describe "a schools_requiring controller", :shared => true do
    before(:each) do
      controller.should_receive(:require_current_school).any_number_of_times.and_return(true)
      controller.class.before_filters.should include(:require_current_school) 
    end
  end


  
  describe "an authenticated controller", :shared => true do
    before(:each) do
      controller.should_receive(:authenticate).any_number_of_times.and_return(true)
      controller.class.before_filters.should include(:authenticate) 
    end
  end


  describe "an authorized controller", :shared => true do
    before(:each) do
     controller.should_receive(:authorize).any_number_of_times.and_return(true)
     controller.class.before_filters.should include(:authorize)
    end

    it 'should have all actions in action_groups (read or write for now.)' do
      controller.class.public_instance_methods(false).each do |public_action|
        controller.stub!(:action_name => public_action.to_s)
        # controller.send(:action_group_for_current_action).should_not be_nil
        flunk public_action.to_s if controller.send(:action_group_for_current_action).blank?
      end
    end
  end
end


