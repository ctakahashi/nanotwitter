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


get '/' do
	erb :index
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
	@temp_user = "ctaka"
	@tweet = Tweet.create(text: params[:tweet_text],
						  user_id: User.find_by_username(@temp_user).id)
	if @tweet.valid?
		redirect "/user/#{@temp_user}"
	end
end

get '/login' do
	@check = User.find_by_username(params[:username])

	if @check
		if @check.password == params[:password]
			erb :home_feed
		else
			erb :login_error
		end
	else
		erb :login_error
	end
end

get '/logout' do
	erb :logged_out
end

get '/signup' do
	erb :signup
end

get '/resetpassword' do 
	erb :resetPass
end

get '/profile' do 
	erb :profile
end

get '/settings' do 
	erb :settings
end

get '/user/:username' do
	erb :profile
end

# get '/tweet/:id' do
# 	erb :tweet
# end

