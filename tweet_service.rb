post '/tweet' do
	user = User.find(session[:user_id])
	@tweet = Tweet.create(text: params[:tweet_text],
						  user_id: session[:user_id])
	if @tweet.valid?
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

  	if session[:user_id]
  		erb :searchPage
  	else
   		erb :searchPage, :layout => :notSignedIn
	end
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
	$redis.lpush("home_page_feed", {:text => tweet.text,
			 						:created_at => tweet.created_at,
			 						:username => user.username,
			 						:pic => user.pic}.to_json)
	$redis.rpop("home_page_feed")	
	followers = $redis.lrange("l#{user.id}", 0, -1)
	followers.each do |follower|
		$redis.lpush("f#{follower}", "#{tweet.id}")
		$redis.rpop("f#{follower}")
	end
end