source 'http://rubygems.org'

gem 'rails', '3.0.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano', :require => false
gem 'capistrano-ext', :require => false

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

gem 'cells'
gem 'subdomain-fu', '1.0.0.beta2', :git => "git://github.com/nhowell/subdomain-fu.git"
gem 'hoptoad_notifier'
gem 'memcache-client'

gem 'newrelic_rpm'

gem 'ruport', '1.6.1'
gem 'acts_as_reportable', '1.1.1', :require => 'ruport/acts_as_reportable'
gem 'pdf-writer', :require => 'pdf/writer'
gem 'system_timer'
gem 'googlecharts'
gem 'responds_to_parent'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test, :cucumber do
   gem 'cucumber', :require => false
   gem 'cucumber-rails',  '>=0.3.0', :require => false
   gem 'database_cleaner','>=0.5.0', :require => false
   gem 'webrat',          '>=0.7.0', :require => false
   gem 'rspec',           '>=1.3.0', :require => false
   gem 'rspec-rails',     '>=1.3.2', :require => false
   gem 'nokogiri', :require => false
   gem 'hpricot', '=0.6.161', :require => false

 end
