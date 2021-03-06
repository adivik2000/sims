# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)
require 'logger'

class SessionCheck
  def self.call(env)
    if env["PATH_INFO"] =~ /^\/session_check/
      [200, {"Content-Type" => "text/html"}, [check(env)]]
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end

  def self.check(env)
    session=env["rack.session"]
    params=Rack::Request.new(env).params

    #move this to metal
    result=""
    if params['user_id'].present?
      if params['current_student_id'].present? && (session[:selected_student].to_s != params['current_student_id'].to_s)
        result += "Currently, you cannot select two different students in different windows or tabs.    "
      end
      if session[:user_id].to_s != params['user_id'].to_s
        result += "You've been logged out or another user is using SIMS in another window or tab."
      end
    end


    if result.present?
      log = Logger.new Rails.root.join('log','session_check.log')
      result = "<br />Using multiple windows or tabs can cause errors or misplaced data in SIMS.  If you are seeing this message, you should
      close this window.<br /> " + result
      log.info "#{Time.now}- session user-#{session[:user_id]}, student-#{session[:selected_student]} -- page user-#{params['user_id']}, student-#{params['current_student_id']} "
    end
      result

  end
end
