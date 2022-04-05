source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.5'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.4'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'

gem 'devise'

gem 'bootstrap', '~> 5.1.3'

gem 'jquery-rails'

gem 'will_paginate', '~> 3.3.1'

gem 'bootstrap-will_paginate'

gem 'acts_as_follower', github: 'tcocca/acts_as_follower', branch: 'master'

gem 'acts-as-taggable-on', '~> 9.0'

gem 'rails-i18n'

gem 'friendly_id', '~> 5.4.0'

gem 'rails-bootstrap-tabs', '~> 0.2.7'

gem 'rack-attack'

gem 'route_downcaser'

gem 'rails-html-sanitizer'

gem 'strong_password', '~> 0.0.9'

gem 'http_accept_language'

gem 'redis'

gem 'shrine', '~> 3.0'

gem 'image_processing', '~> 1.8'

gem 'sidekiq', '~> 6.4'

gem 'marcel'

gem 'fastimage'

gem 'aws-sdk-s3'

gem 'streamio-ffmpeg'

gem 'uglifier'

gem 'yui-compressor'

gem 'rails_autolink'

gem 'predictor'

gem 'hiredis'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.3'
  gem 'listen', '~> 3.7'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'brakeman'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
