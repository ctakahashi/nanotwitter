post '/tweet' do
	user = User.find(session[:user_id])
	@tweet = Tweet.create(text: params[:tweet_text],
						  user_id: session[:user_id])
	if @tweet.valid?
		# REDIS.get(:recent_tweets).unshift(@tweet)
		# REDIS.get(:recent_tweets).pop
		@@recent_tweets.unshift(:text => @tweet.text,
									:created_at => @tweet.created_at,
									:username => user.username,
									:pic => user.pic)
		@@recent_tweets.pop
		redirect "/user/#{user.username}"
		@@tweet_count += 1
	else
		error 404, {:error => "The tweet was invalid!"}
	end
end

post '/search' do 
		puts params[:search]   
    @users = User.search(params[:search]).order("created_at DESC")
    puts @users
    erb :searchPage
end

get '/tweet/:id' do
	erb :tweet
end

