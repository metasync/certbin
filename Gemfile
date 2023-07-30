# frozen_string_literal: true

source 'https://rubygems.org'

gem 'hanami', '~> 2.0'
gem 'hanami-router', '~> 2.0'
gem 'hanami-controller', '~> 2.0'
gem 'hanami-validations', '~> 2.0'

gem 'dry-types', '~> 1.0', '>= 1.6.1'
gem 'puma'
gem 'rake'

gem 'rom', '~> 5.3'
gem 'rom-sql', '~> 3.6'
gem 'tiny_tds', '~> 2.1'
gem 'pg', '~> 1.4'

gem 'jwt', '~> 2.7'
gem 'dry-monads', '~> 1.6'
gem 'dry-effects', '~> 0.4'

group :development, :test do
  gem 'dotenv'
  gem 'amalgalite', '~> 1.6', '>= 1.6.3'
end

group :cli, :development do
  gem 'hanami-reloader'
end

group :cli, :development, :test do
  gem 'hanami-rspec'
end

group :development do
  gem 'guard-puma', '~> 0.8'
  gem 'rubocop', '~> 1.50', require: false
  gem 'rubocop-rspec', '~> 2.20', require: false
end

group :test do
  gem 'rack-test'
  gem 'database_cleaner-sequel'
end
