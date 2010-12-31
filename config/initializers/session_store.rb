# Be sure to restart your server when you modify this file.

domain=nil
domain =  ".#{SIMS_DOMAIN}" if defined? SIMS_DOMAIN
    

ActionController::Base.session = sessionhash



Sims::Application.config.session_store :cookie_store, :key => '_sims_session', :domain => domain

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Sims::Application.config.session_store :active_record_store
