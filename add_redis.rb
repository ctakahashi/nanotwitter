require 'sinatra'
require 'active_record'
require "sinatra/activerecord"
require './config/environments'
require './models/user'
require './models/tweet'

def reset 
	(0..1100).each do |user|
		$redis.del("user#{user}")
	end
end

reset 

tweets = Tweet.all

tweets.each do |tweet|
	user = User.find(tweet.user_id)
	$redis.lpush("{tweet.user_id}", "#{tweet.id}")
	$redis.lpush("recentTweets", "#{tweet.id}")
	if $redis.llen("recentTweets") >= 100
		$redis.ltrim("recentTweets", 0, 99)
	end
end



