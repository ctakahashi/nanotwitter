post '/tweet' do
	user = User.find(session[:user_id])
	@tweet = Tweet.create(text: params[:tweet_text],
						  user_id: session[:user_id])
	if @tweet.valid?
		$redis.lpush("#{@tweet.user_id}", "#{@tweet.id}")  #added recently 4/20/2015
		
		# @@recent_tweets.unshift(:text => @tweet.text,
		# 							:created_at => @tweet.created_at,
		# 							:username => user.username,
		# 							:pic => user.pic)
		# @@recent_tweets.pop
		new_tweets(user, @tweet)
		redirect "/user/#{user.username}"
		@@tweet_count += 1
	else
		error 404, {:error => "The tweet was invalid!"}
	end
end

post '/search' do 
	puts params[:search]
	search_phrase = params[:search]
	if search_phrase[0] == '@'
    	@users = User.search(search_phrase[1..-1]).order("created_at DESC").limit(100)
    elsif search_phrase[0] == '#'
    	@tweets = Tweet.search(search_phrase[1..-1]).order("created_at DESC").limit(100)
    end
    erb :searchPage
end

get '/tweet/:id' do
	@tweet = Tweet.find(params[:id])
	user = User.find(@tweet.user_id)
	if session[:user_id]
		if user
			current = User.find(session[:user_id])
			erb :tweet, :locals => {:name => user.name,
									  :username => user.username, 
									  :tweets => user.tweets[0..99],
									  :pic => user.pic || Faker::Avatar.image,
									  :user_id => user.id,
									  :user => user,
									  :me => current,
									  :current_user => user.id == session[:user_id],
									  :logged_in_user => true			  
									}
		else
			error 404, {:error => "The user is not found."}.to_json
		end
	else 
		if user
			erb :tweet, :layout => :notSignedIn, :locals => {:name => user.name,
									  :username => user.username, 
									  :tweets => user.tweets[0..99],
									  :pic => user.pic || Faker::Avatar.image,
									  :user_id => user.id,
									  :user => user,
									  :current_user => false,
									  :logged_in_user => false
									}
		else
			error 404, {:error => "The tweet is not found and you are not logged in."}.to_json
		end 
	end
end

def new_tweets(user, tweet)
	$redis.lpush("#{tweet.user_id}", "#{tweet.id}")
	followers = $redis.get("l#{user.id}")
	followers.each do |follower|
		$redis.lpush("f#{follower.id}", "#{tweet.id}")
		$redis.rpop("f#{follower.id}")
	end
end