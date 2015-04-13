require 'json'
require 'sinatra'
require 'newrelic_rpm'
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
require './tweet_service.rb'
require './user_service.rb'
require './follow_service.rb'
require './api_service.rb'

configure { set :server, :puma }

enable :sessions
enable :method_override



set :environment, :development

# size = Tweet.all.count
# @@recent_tweets = Tweet.all[size - 101..size - 1].reverse

@@recent_tweets = nil

class App < Sinatra::Base
	register Sinatra::AssetPack
	assets do
		serve '/js', :from => 'public/js'
		js :application, [
			'/js/jquery.js',
			'/js/app.js'
		]
		serve '/js', :from => 'public/css'
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
		# @one_k_tweets = Tweet.all
		# @recent_tweets = Tweet.all.sort_by{|tweet| tweet.created_at}[Tweet.all.size - 101..Tweet.all.size - 1].reverse
		last_id = Tweet.last.id
		unless @@recent_tweets
			@@recent_tweets = []
			count = 0
			while @@recent_tweets.size < 100 do
				if Tweet.exists?(last_id - count)
					@@recent_tweets.push(Tweet.find(last_id - count))
				end
				count += 1
			end
		end
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
						email: params[:email],
						pic: Faker::Avatar.image
						)

	if @user.valid?
		#erb :index, :layout => :notSignedIn
		session[:user_id] = @user.id
		redirect 'profile'
	else
		erb :signup
	end
end

get '/login' do
	@check = User.find_by_username(params[:username])

	if @check
		if @check.password == params[:password]
			session[:user_id] = @check.id
			redirect '/profile'
		else
			erb :login_error, :layout => :notSignedIn
		end
	else
		erb :login_error, :layout => :notSignedIn
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

get '/about_us' do
	erb :aboutus
end

get '/loaderio-6506d5de4416788ad7352f30b15c85b5/' do
	erb :loader, :layout => nil
end


get '/loaderio-d273dacb1e46de4b1a381b41807320f2/' do
	"loaderio-d273dacb1e46de4b1a381b41807320f2"
end
##########split here?

# post '/tweet' do
# 	username = User.find(session[:user_id]).username
# 	@tweet = Tweet.create(text: params[:tweet_text],
# 						  user_id: session[:user_id])
# 	if @tweet.valid?
# 		redirect "/user/#{username}"
# 	end
# end

# post '/search' do
# 		puts params[:search]
#     @users = User.search(params[:search]).order("created_at DESC")
#     puts @users
#     erb :searchPage
# end

# get '/tweet/:id' do
# 	erb :tweet
# end

##########split here?


# get '/profile' do
# 	if session[:user_id]
# 		user = User.find(session[:user_id])
# 		if user
# 			erb :profile, :locals => {:name => user.name,
# 									  :username => user.username,
# 									  :tweets => user.tweets,
# 									  :user => user,
# 									  :current_user => true,
# 									  :logged_in_user => true,
# 									  :pic => user.pic || Faker::Avatar.image
# 									}
# 		else
# 			error 404, {:error => "The user is not found or you are not logged in."}.to_json
# 		end
# 	else
# 		error 404, {:error => "You are not logged in."}.to_json
# 	end
# end

# get '/home' do
# 	if session[:user_id]
# 		user = User.find(session[:user_id])
# 		if user
# 			following_tweets = Array.new
# 			user.following.each do |followed_user|
# 				followed_user.tweets.each do |tweet|
# 					following_tweets.push(tweet)
# 				end
# 			end
# 			following_tweets.sort_by!{|tweet| tweet.created_at}
# 			erb :profile, :locals => {:name => user.name,
# 									  :username => user.username,
# 									  :tweets => following_tweets,
# 									  :user => user,
# 									  :current_user => true,
# 									  :logged_in_user => true,
# 									  :pic => user.pic || Faker::Avatar.image
# 									}
# 		else
# 			error 404, {:error => "The user is not found or you are not logged in."}.to_json
# 		end
# 	else
# 		error 404, {:error => "You are not logged in."}.to_json
# 	end
# end

# get '/settings' do
# 	erb :settings
# end

# put '/edit' do
# 	@user = User.find(session[:user_id])
# 	if @user
# 		params.delete_if { |key, value| value == "" || value == "PUT" }
# 		@user.update_attributes(params)
# 		redirect '/profile'
# 	else
# 		error 404, {:error => "You're not logged in. Please go back and log in."}
# 	end

# end


# get '/user/:username' do

# 	user = User.find_by_username(params[:username])

# 	if session[:user_id]
# 		if user
# 			if user.id == session[:user_id]
# 				redirect '/profile'
# 			else
# 				current = User.find(session[:user_id])
# 				erb :profile, :locals => {:name => user.name,
# 										  :username => user.username,
# 										  :tweets => user.tweets,
# 										  :pic => user.pic || Faker::Avatar.image,
# 										  :user_id => user.id,
# 										  :user => user,
# 										  :me => current,
# 										  :current_user => false,
# 										  :logged_in_user => true
# 										}
# 			end
# 		else
# 			error 404, {:error => "The user is not found."}.to_json
# 		end
# 	else
# 		if user
# 			erb :profile, :layout => :notSignedIn, :locals => {:name => user.name,
# 									  :username => user.username,
# 									  :tweets => user.tweets,
# 									  :pic => user.pic || Faker::Avatar.image,
# 									  :user_id => user.id,
# 									  :user => user,
# 									  :current_user => false,
# 									  :logged_in_user => false
# 									}
# 		else
# 			error 404, {:error => "The user is not found and you are not logged in."}.to_json
# 		end
# 	end
# end

##########split here?

# get '/user/:username/follow' do
# 	if session[:user_id]
# 		follower = User.find(session[:user_id])
# 		leader= User.find_by_username(params[:username])
# 		username=leader.username
# 		follower.follow(leader)
# 		redirect "/user/#{username}"
# 	end
# end

# get '/user/:username/unfollow' do
# 	if session[:user_id]
# 		follower = User.find(session[:user_id])
# 		leader= User.find_by_username(params[:username])
# 		username=leader.username
# 		follower.unfollow(leader)
# 		redirect "/user/#{username}"
# 	end
# end
