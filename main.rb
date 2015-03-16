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

enable :sessions

get '/' do
	if session[:username]
		erb home_feed
	else
		erb :index
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
	# session[:user_id] = nil
	# redirect '/'
end

get '/signup' do
	erb :signup
end

get '/resetpassword' do 
	erb :resetPass
end

get '/profile' do 
	user = User.find(session[:user_id])
	if user
		erb :profile, :locals => {:name => user.name, :username => user.username, :tweets => user.tweets}
	else
		error 404, {:error => "The user is not found or you are not logged in."}.to_json
	end
end

get '/settings' do 
	erb :settings
end

get '/user/:username' do
	user = User.find_by_username(params[:username])
	
	if user.id == session[:user_id]
		redirect '/profile'
	elsif user
		erb :profile, :locals => {:name => user.name, :username => user.username, :tweets => user.tweets}
	else
		error 404, {:error => "The user is not found."}.to_json
	end
end

# get '/tweet/:id' do
# 	erb :tweet
# end

