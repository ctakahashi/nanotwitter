get '/profile' do 
	if session[:user_id]
		user = User.find(session[:user_id])
		if user.username == "test_user"
			redirect '/home'
		end
		if user
			tweets_list = $redis.lrange("#{user.id}", 0, 99)
			# tweets = tweets_list.collect { |tweet| Tweet.find(tweet) }
			tweets = Tweet.where(id: tweets_list)
			erb :home_feed, :locals => {:name => user.name,
									  :username => user.username, 
									  :tweets => tweets, 
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
			# following_tweets = Array.new
			# user.following.each do |followed_user|
			# 	following_tweets.concat(followed_user.tweets.last(100))
			# end
			following_tweets = Tweet.where(id: $redis.lrange("f#{user.id}", 0, 99))
			#user.following.each do |followed_user|
			# => redis_indices = $redis.lrange("#{followed_user.id}", 0, 99)
			# => redis_tweets = redis_indices.map |tweet| to an actual tweet
			# => following_tweets.concat(redis_tweets)
			#end

			# following_tweets.sort_by!{|tweet| tweet.created_at}
			erb :profile, :locals => {:name => user.name,
									  :username => user.username, 
									  :tweets => following_tweets[0..99], 
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
										  # :tweets => user.tweets[0..99],
										  :tweets => Tweet.where(id: $redis.lrange("#{user.id}", 0, 99) ).to_a,
										  :pic => user.pic || Faker::Avatar.image,
										  :user_id => user.id,
										  :user => user,
										  :me => current,
										  :current_user => false,
										  :logged_in_user => session[:user_id]										  
										}
			end
		else
			error 404, {:error => "The user is not found."}.to_json
		end
	else 
		if user
			erb :profile, :layout => :notSignedIn, :locals => {:name => user.name,
									  :username => user.username, 
									  # :tweets => user.tweets[0..99],
									  :tweets => Tweet.where(id: $redis.lrange("#{user.id}", 0, 99) ).to_a,
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