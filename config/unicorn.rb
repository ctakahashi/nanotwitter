# config/unicorn.rb
worker_processes 7 #Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 15
preload_app true