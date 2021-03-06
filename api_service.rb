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
		error 404, {:error => "That username is not found in the database"}.to_json
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

get '/api/v1/tweets/recent/?:num?' do
	tweets = []
	number_of_tweets = params[:num] || 10
	last_id = Tweet.last.id
	total_tweets_count = Tweet.count
	count = 0
	while tweets.size < number_of_tweets.to_i && count < last_id do
		if Tweet.exists?(last_id - count)
			tweets.push(Tweet.find(last_id - count))
		end
		count += 1
	end
	tweets.to_json
end

get '/api/v1/all_tweets' do 
	Tweet.all.to_json
end
