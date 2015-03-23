require 'json'
require 'sinatra'
require 'active_record'
require "sinatra/activerecord"
require 'pry'
require 'faker'
require './config/environments'
require './models/user'
require './models/tweet'
require './models/bond'
require './models/comment'
require './models/retweet'
require 'sinatra/base'
require 'sinatra/assetpack'

enable :sessions
enable :method_override
class App < Sinatra::Base
	register Sinatra::Application
	assets do
		js :application, [
			'/js/jquery.js',
			'/js/app.js'
		]

		css :application, [
			'/css/jqueryui.css',
			'/css/reset.css',
			'/css/foundation.css',
			'/css.app.css']

		js_compression :jsmin
		css_compression :sass
	end

end
get '/' do
	if session[:user_id]
		redirect '/home'
	else
		erb :index, :layout => :notSignedIn
	end
end

#post '/login' do
	#<check>
	#if <check> == true
	#	erb <home feed>
	#else 
	#	erb<login with failed text>
	#end
	#redirect '/home'
#end
post '/register' do
	# @n = User.new
	# @n.name = params[:name]
	# @n.user_name=params[:uname]
	# @n.password=params[:password]
	# @n.email=params[:email]
	# @n.save

	@user = User.create(name: params[:name],
						username: params[:uName],
						password: params[:pass],
						email: params[:email]
						)

	if @user.valid?
		redirect "/user/#{@user.username}"
	else
		erb :signup
	end
end

post '/tweet' do
	username = User.find(session[:user_id]).username
	@tweet = Tweet.create(text: params[:tweet_text],
						  user_id: session[:user_id])
	if @tweet.valid?
		redirect "/user/#{username}"
	end
end

post '/search' do 
		puts params[:search]   
    @users = User.search(params[:search]).order("created_at DESC")
    puts @users
    erb :searchPage
end

get '/login' do
	@check = User.find_by_username(params[:username])

	if @check
		if @check.password == params[:password]
			session[:user_id] = @check.id
			redirect '/profile'
		else
			erb :login_error
		end
	else
		erb :login_error
	end
end

get '/logout' do
	 session[:user_id] = nil
	 redirect '/'
end

get '/signup' do
	erb :signup, :layout => :notSignedIn
end

get '/resetpassword' do 
	erb :resetPass, :layout => :notSignedIn
end

get '/profile' do 
	if session[:user_id]
		user = User.find(session[:user_id])
		if user
			erb :profile, :locals => {:name => user.name,
									  :username => user.username, 
									  :tweets => user.tweets, 
									  :user => user,
									  :current_user => true,
									  :logged_in_user => true,
									  :pic => user.pic || Faker::Avatar.image
									}
		else
			error 404, {:error => "The user is not found or you are not logged in."}.to_json
		end
	else
		error 404, {:error => "You are not logged in."}.to_json
	end
end

get '/home' do 
	if session[:user_id]
		user = User.find(session[:user_id])
		if user
			following_tweets = Array.new
			user.following.each do |followed_user|
				followed_user.tweets.each do |tweet|
					following_tweets.push(tweet)
				end
			end
			following_tweets.sort_by!{|tweet| tweet.created_at}
			erb :profile, :locals => {:name => user.name,
									  :username => user.username, 
									  :tweets => following_tweets, 
									  :user => user,
									  :current_user => true,
									  :logged_in_user => true,
									  :pic => user.pic || Faker::Avatar.image
									}
		else
			error 404, {:error => "The user is not found or you are not logged in."}.to_json
		end
	else
		error 404, {:error => "You are not logged in."}.to_json
	end
end

get '/settings' do 
	erb :settings
end

put '/edit' do
	@user = User.find(session[:user_id])
	if @user
		params.delete_if { |key, value| value == "" || value == "PUT" }
		@user.update_attributes(params)
		redirect '/profile'
	else
		error 404, {:error => "You're not logged in. Please go back and log in."}
	end

end


get '/user/:username' do

	user = User.find_by_username(params[:username])

	if session[:user_id]
		if user
			if user.id == session[:user_id]
				redirect '/profile'
			else
				current = User.find(session[:user_id])
				erb :profile, :locals => {:name => user.name,
										  :username => user.username, 
										  :tweets => user.tweets,
										  :pic => user.pic || Faker::Avatar.image,
										  :user_id => user.id,
										  :user => user,
										  :me => current,
										  :current_user => false,
										  :logged_in_user => true										  
										}
			end
		else
			error 404, {:error => "The user is not found."}.to_json
		end
	else 
		if user
			erb :profile, :layout => :notSignedIn, :locals => {:name => user.name,
									  :username => user.username, 
									  :tweets => user.tweets,
									  :pic => user.pic || Faker::Avatar.image,
									  :user_id => user.id,
									  :user => user,
									  :current_user => false,
									  :logged_in_user => false
									}
		else
			error 404, {:error => "The user is not found and you are not logged in."}.to_json
		end 
	end
end

get '/user/:username/follow' do
	if session[:user_id]
		follower = User.find(session[:user_id])
		leader= User.find_by_username(params[:username])
		username=leader.username	
		follower.follow(leader)	
		redirect "/user/#{username}"
	end
end

get '/user/:username/unfollow' do
	if session[:user_id]
		follower = User.find(session[:user_id])
		leader= User.find_by_username(params[:username])
		username=leader.username	
		follower.unfollow(leader)	
		redirect "/user/#{username}"
	end
end
get '/tweet/:id' do
	erb :tweet
end