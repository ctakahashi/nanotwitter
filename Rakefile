require './main.rb'
require 'sinatra/activerecord/rake'

enable :method_override
APP_FILE  = 'main.rb'
APP_CLASS = 'App'
require 'sinatra/assetpack/rake'
# task :default => :test
require 'rspec/core/rake_task'
task :default => :spec
RSpec::Core::RakeTask.new