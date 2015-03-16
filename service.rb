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

# Get information about a specific user with his or her username
get '/api/v1/users/:username' do 
	user = User.find_by_name(params[:username])
	if user
		user.to_json
	else
		error 404, {:error => "That username is not found in our database"}.to_json
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
	number_of_tweets = params[:num] || 10
	(0..number_of_tweets).each do |tweet|
		tweets.push(Tweet.find(tweet))
	end
end