require './main.rb'
require 'sinatra/activerecord/rake'
require 'sinatra/assetpack/rake'
enable :method_override
APP_FILE  = 'main.rb'
APP_CLASS = 'App'

# task :default => :test
require 'rspec/core/rake_task'
task :default => :spec
RSpec::Core::RakeTask.new