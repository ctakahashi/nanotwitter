# @@test_user =  User.find_by_username("test_user")

get '/test_tweet' do
	test_user = User.find_by_username("test_user")

	@tweet = Tweet.create(text: Faker::Lorem.sentence,
					  	user_id: test_user.id)
	if @tweet.valid?
		new_tweets(test_user, @tweet)
		# @@tweet_count += 1
		"test_user has tweeted!"
	end
end

get '/test_follow' do
	if session[:user_id] != 1006 then session[id] = 1006 end
	test_user = User.find_by_username("test_user")

	user_id = rand(1..User.count)
	user = User.find(user_id)
	if test_user.following?(user)
		test_user.unfollow(user)
		remove_follower(test_user, user)
	else
		test_user.follow(user)
		adjust_home(test_user)
	end
	"test_user has followed/unfollowed someone!"
end

get '/reset' do
	test_user = User.find_by_username("test_user")
	Tweet.where(user_id: test_user.id).destroy_all
	test_user.following.each do |user|
		test_user.unfollow(user)
		remove_follower(test_user, user)
	end
	$redis.rpop "home_page_feed"
	redirect '/'
end