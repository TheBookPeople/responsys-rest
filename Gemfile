source 'https://rubygems.org'

ruby '2.2.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

gem 'responsys-api', git: 'https://github.com/TheBookPeople/responsys-api.git',  branch: 'upgrade-for-rails-4.2'

gem 'puma', '~> 2.11'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
gem "codeclimate-test-reporter", group: :test, require: nil
end

gem 'rubocop', '~> 0.30.1', require: false

gem 'sys-filesystem', '~> 1.1'

gem 'pkgr', '~> 1.4'

group :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'vcr', '~> 2.9'
  gem 'webmock', '~> 1.21'
  gem 'guard', '~> 2.12'
  gem 'guard-rspec', require: false
  gem 'simplecov', '~> 0.10', :require => false
  gem 'timecop', '~> 0.7'
end

group :production do
  gem 'rails_12factor', '~> 0.0.3'
end


