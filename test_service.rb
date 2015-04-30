# @@test_user =  User.find_by_username("test_user")

get '/test_tweet' do

	@tweet = Tweet.create(text: Faker::Lorem.sentence,
					  	user_id: @@test_user.id)
		@@recent_tweets.unshift(:text => @tweet.text,
									:created_at => @tweet.created_at,
									:username => @@test_user.username,
									:pic => @@test_user.pic)
		@@recent_tweets.pop
		@@tweet_count += 1
		"test_user has tweeted!"
end

get '/test_follow' do
	user_id = rand(1..User.count)
	user = User.find(user_id)
	if @@test_user.following?(user)
		@@test_user.unfollow(user)
	else
		@@test_user.follow(user)
	end
	"test_user has followed/unfollowed someone!"
end

get '/reset' do
	@@tweet_count -= Tweet.where(user_id: @@test_user.id).count
	Tweet.where(user_id: @@test_user.id).destroy_all
	@@test_user.following.each do |user|
		@@test_user.unfollow(user)
	end
	last_id = Tweet.last.id
	@@recent_tweets = []
	count = 0
	while @@recent_tweets.size < 100 && count < last_id do
		if Tweet.exists?(last_id - count)
			tweet = Tweet.find(last_id - count)  #.includes(:text, :created_at)
			user = User.find(tweet.user_id)  #.includes(:username, :pic)
			@@recent_tweets.push(:text => tweet.text,
							:created_at => tweet.created_at,
							:username => user.username,
							:pic => user.pic)
		end
		count += 1
	end
	"Reset successful."
end