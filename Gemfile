source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Core
gem 'rails', '~> 5.2.4'

# MiddleWare
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'bcrypt', '~> 3.1.13'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'mini_magick', '~> 4.8'
gem 'carrierwave'

# ViewFront
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'kaminari'

# Debug, Framework, Test
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'spring'
  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  # gem 'letter_opener_web'
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails'
  gem 'spring-commands-rspec'
  gem 'faker'
  gem 'gimei'  
  gem 'launchy'  
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  #gem 'webdriver'
  gem 'selenium-webdriver'  
  gem 'chromedriver-helper'
end
