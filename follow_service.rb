get '/user/:username/follow' do
	if session[:user_id]
		follower = User.find(session[:user_id])
		leader= User.find_by_username(params[:username])
		username=leader.username	
		follower.follow(leader)	
		redirect "/user/#{username}"
	end
end

get '/user/:username/unfollow' do
	if session[:user_id]
		follower = User.find(session[:user_id])
		leader= User.find_by_username(params[:username])
		username=leader.username	
		follower.unfollow(leader)	
		redirect "/user/#{username}"
	end
end