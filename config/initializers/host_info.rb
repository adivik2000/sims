#SIMS_DOMAIN = #sims-open.vegantech.com
SIMS_PROTO="http"  #change to https when we're using that.
#DEFAULT_URL = #'http://www.simspilot2.org:3000'


# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

host="www.#{Object.const_get("SIMS_DOMAIN")}" if Object.const_defined?('SIMS_DOMAIN')
ActionMailer::Base.default_url_options = {
  :only_path => false,
  :protocol => SIMS_PROTO,
  :host => host ||"www.sims_test_host"
}
  
