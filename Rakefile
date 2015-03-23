require './main.rb'
require 'sinatra/activerecord/rake'

enable :method_override

# task :default => :test
require 'rspec/core/rake_task'
task :default => :spec
RSpec::Core::RakeTask.new