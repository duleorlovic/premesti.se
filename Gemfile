source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# for fonts
gem 'non-stupid-digest-assets'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'hiredis'
gem 'redis', require: ['redis', 'redis/connection/hiredis']
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :development do
  gem 'capistrano', '~> 3.11'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rails', '~> 1.4'
  gem 'capistrano-rails-logs-tail'
  gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'
  gem 'capistrano-sidekiq'
  gem 'capistrano-faster-assets'
  gem 'jekyll'
  gem 'google-cloud-translate'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'chromedriver-helper'
  gem 'factory_bot_rails'
  gem 'guard'
  gem 'guard-livereload', require: false
  gem 'guard-minitest'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'minitest-focus'
  gem 'rack-livereload'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  # open emails in browser
  gem 'letter_opener'
  gem 'meta_request'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'devise-neo4j'
# gem 'neo4j', '~> 9.0.0'
gem 'neo4j' # , github: 'neo4jrb/neo4j'
gem 'neo4j-core', github: 'neo4jrb/neo4j-core'
gem 'neo4j-rake_tasks', github: 'duleorlovic/neo4j-rake_tasks'

# bootstrap_form_for
gem 'bootstrap_form',
    git: 'https://github.com/bootstrap-ruby/bootstrap_form.git',
    branch: 'master'

# omniauth
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

# mail style and generate txt from html
gem 'premailer-rails'

# inline svg inside html
gem 'inline_svg'

# for automatic translation
gem 'cyrillizer'

# adding vendor prefixes (webkit) to css rules
# gem 'autoprefixer-rails'

# error notification to EXCEPTION_RECIPIENTS emails
gem 'exception_notification'

# background proccessor
gem 'sidekiq'

# captcha on contact form
gem 'recaptcha'

# pagination
gem 'kaminari'
gem 'kaminari-neo4j'

# sets timezone based on browser timezone for each request
gem 'browser-timezone-rails'

# for profiling
# gem 'rack-mini-profiler'

gem 'webpacker'

# datatables
gem 'trk_datatables', '0.2.3'
# gem 'trk_datatables', path: '~/gems/trk_datatables'

gem 'sitemap_generator'
