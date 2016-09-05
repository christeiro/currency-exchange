source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

gem 'devise', '~> 4.2'
gem 'money', '~> 6.7'
gem 'haml-rails', '~> 0.9'
gem 'bootstrap', '~> 4.0.0.alpha3.1'
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end
gem 'font-awesome-rails'
gem 'sidekiq'
gem 'sinatra', github: 'sinatra', require: false
gem 'slim'
gem 'faraday', '~> 0.9'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'fabrication', '~> 2.14'
  gem 'faker', '~> 1.6'
  gem 'pry'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'warden', '~> 1.2'
  gem 'rails-controller-testing', '~> 1.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
