require 'json'
require 'sinatra'
require 'active_record'
require "sinatra/activerecord"
require 'pry'
require './config/environments'
require './models/user'
require './models/tweet'
require './models/bond'
require './models/comment'
require './models/retweet'

# Get information about a specific user with his or her id
get '/api/v1/users/:id' do 
	user = User.find(params[:id])
	if user
		user.to_json
	else
		error 404, {:error => "That username is not found in our database"}.to_json
	end
end

get '/api/v1/users/:id/tweets' do
	user = User.find(params[:id])

	if user
		all_tweets = user.tweets
		if all_tweets
			all_tweets.to_json
		else
			error 404, {:error => "User has no tweets"}.to_json
		end
	else
		error 404, {:error => "User does not exist"}.to_json
	end

end

get '/api/v1/tweets/:id' do
	tweet = Tweet.find(params[:id])

	if tweet
		tweet.to_json
	else
		error 404, {:error => "That tweet doesn't exist?!"}.to_json
	end
end

get '/api/v1/tweets/recent/:num' do
	tweets = []
	number_of_tweets = params[:num].to_i || 10
	tweets_list = Tweet.all.reverse
	(0..number_of_tweets).each do |tweet|
		tweets.push(tweets_list[tweet])
	end
	tweets.to_json
end

# get '/api/v1/users/:id/comments' do
# 	user = User.find(params[:id])

# 	if user
# 		all_comments = user.comments
# 		if comments
# 			all_comments.to_json
# 		else
# 			error 404, {:error => "User never made any comments"}.to_json
# 		end
# 	else
# 		error 404, {:error => "User does not exist"}.to_json
# 	end
end