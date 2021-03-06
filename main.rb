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
require './tweet_service.rb'
require './user_service.rb'
require './follow_service.rb'
require './api_service.rb'
require 'sinatra/paginate'
require './test_service.rb'

# configure { set :server, :puma }

enable :sessions
#enable :method_override

# set :environment, :development

$redis.del("home_page_feed")

Struct.new('Result', :total, :size, :users)
class App < Sinatra::Base
	register Sinatra::AssetPack
	register Sinatra::Paginate
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

	helpers do
		def page
			[params[:page].to_i - 1, 0].max
		end
	end

	get '/page' do
		@users = User.all(limit: 10, offset: page * 10)
		@result = Struct::Result.new(User.count, @users.count, @users)
    	erb :page
	end
end

get '/' do
	if session[:user_id]
		redirect '/home'
	else
		unless $redis.llen("home_page_feed") == 100
			tweets = Tweet.all.order(created_at: :desc).limit(100).to_a.reverse
		
			tweets.each do |tweet|
				user = User.find(tweet.user_id)
				$redis.lpush("home_page_feed", {:text => tweet.text,
			 						:created_at => tweet.created_at,
			 						:username => user.username,
			 						:pic => user.pic}.to_json)
			end
			$redis.ltrim("home_page_feed", 0, 99)
		end


		@recent_tweets = $redis.lrange("home_page_feed", 0, -1).collect { |tweet| JSON.parse(tweet) }
	
		erb :index, :layout => :notSignedIn
	end
end

post '/register' do
	@user = User.create(name: params[:name],
						username: params[:uName],
						password: params[:pass],
						email: params[:email],
						pic: Faker::Avatar.image
						)
	if @user.valid?
		#erb :index, :layout => :notSignedIn
		session[:user_id] = @user.id
		$redis.set("username#{@user.id}", "#{@user.username}")
		$redis.set("pic#{@user.id}", "#{@user.pic}")
		redirect '/profile'
	else
		erb :signup
	end
end

get '/login' do
	@check = User.find_by_username(params[:username])

	if @check
		if @check.password == params[:password]
			session[:user_id] = @check.id
			puts "#{session[:user_id]}"
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
	if session[:user_id]
		erb :aboutus
	else 
		erb :aboutus, :layout => :notSignedIn
	end
end

get '/loaderio-6506d5de4416788ad7352f30b15c85b5/' do
	erb :loader, :layout => nil
end


get '/loaderio-d273dacb1e46de4b1a381b41807320f2/' do
	"loaderio-d273dacb1e46de4b1a381b41807320f2"
end