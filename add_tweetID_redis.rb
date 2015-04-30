require 'sinatra'
require 'active_record'
require "sinatra/activerecord"
require './config/environments'
require './models/user'
require './models/tweet'
require './models/bond'

users = User.all

#list of people who are following you
#users.each do |user|
#	#user = user.find(user_id)
#	leading = user.leading
#	leading.each do |follower|
#		$redis.lpush("l#{user.id}", "#{follower.id}")
#	end
#end

#list of recent tweets of the people you're following (tweet id)
users.each do |user|
	following = user.following
	home_feed = Array.new

	#each user, concat their last 100 tweets to home feed
	following.each do |leading_user|
		their_tweets = leading_user.tweets.last(100)
		home_feed.concat(their_tweets)
	end

	#sort by created at, reverse the order and take the first 100
	home_feed.sort_by! {|tweet| tweet.created_at}
	home_feed = home_feed.reverse[0..99]

	#push the ids of these tweets into redis
	home_feed.each do |tweet|
		$redis.rpush("f#{user.id}", "#{tweet.id}")
		$redis.lpop("f#{user.id}")
	end
end