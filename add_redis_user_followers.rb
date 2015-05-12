require 'sinatra'
require 'active_record'
require "sinatra/activerecord"
require './config/environments'
require './models/user'
require './models/tweet'
require './models/bond'

users = User.all

users.each do |user|
	followers = user.leading.collect { |follow| follow.id }
	followers.each do |follower|
		$redis.lpush("l#{user.id}", follower)
	end
end