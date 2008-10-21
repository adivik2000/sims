require 'test_helper'

class RequireAllControllers < ActiveSupport::TestCase
  # Replace this with your real tests.
  


  #require every rb in app
  Dir.glob(RAILS_ROOT+"/app/controllers/**/*.rb").each do |rb|
    require rb.split("app/").last
  end
 





  # Replace this with your real tests.
  def test_truth
    puts "This just requires all controllers in the project so they show up in code coverage"
    assert true
  end
end
