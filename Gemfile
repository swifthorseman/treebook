source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.1'

group :development do
  gem 'thin'
end

# Use sqlite3 as the database for Active Record (in dev and test)
group :development, :test do
  gem 'sqlite3'
  gem 'awesome_print'
  gem 'log_buddy'
end

group :test do
  gem 'shoulda'
  gem 'factory_girl_rails'
end

group :production do
  gem 'pg'
end

# Devise for Authentication
gem 'devise'

# simple_form for forms
gem 'simple_form'

# FSM
gem 'state_machine'

gem 'draper'
gem 'js-routes'
gem 'paperclip'
gem 'twitter-bootstrap-rails'
gem 'will_paginate'
gem 'bootstrap-will_paginate'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'rails_12factor', group: :production
