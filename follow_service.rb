get '/user/:username/follow' do
	if session[:user_id]
		follower = User.find(session[:user_id])
		leader= User.find_by_username(params[:username])
		username=leader.username	
		follower.follow(leader)	
		$redis.rpush("l#{leader.id}", "#{follower.id}")
		adjust_home(follower)
		redirect "/user/#{username}"
	end
end

get '/user/:username/unfollow' do
	if session[:user_id]
		follower = User.find(session[:user_id])
		leader= User.find_by_username(params[:username])
		username=leader.username	
		follower.unfollow(leader)	
		remove_follower(follower, leader)
		adjust_home(follower)
		redirect "/user/#{username}"
	end
end

def adjust_home(user)
	following = user.following
	home_feed = Array.new

	#each user, concat their last 100 tweets to home feed
	following.each do |leading_user|
		their_tweets = leading_user.tweets.sort_by { |tweet| tweet.created_at }
		their_tweets = their_tweets.last(100)
		home_feed.concat(their_tweets)
	end

	#sort by created at, reverse the order and take the first 100
	home_feed.sort_by! {|tweet| tweet.created_at}
	home_feed = home_feed.reverse[0..99]
	#push the ids of these tweets into redis
	home_feed.each do |tweet|
		$redis.rpush("f#{user.id}", "#{tweet.id}")
	end
end

def remove_follower(follower,leader)
	$redis.LREM("l#{leader.id}", 0 , "#{follower.id}")
	leader_tweets = $redis.lrange("#{leader.id}", 0, -1)
	leader_tweets.each do |tweet_id|
		$redis.LREM("f#{follower.id}", 0, "#{tweet_id}")
	end
end	