source 'https://rubygems.org'

ruby File.read('.ruby-version').strip

gem 'reek', require: false
gem 'rubocop', require: false
gem 'rspec'

eval_gemfile('Gemfile.local.rb') if File.exist?('Gemfile.local.rb')
