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
require 'csv'

CSV.foreach("./seeds/users.csv") do |rows|
		break if rows[0].to_i > 30
		user = User.create(name: rows[1],
				username: rows[1],
				password: "password",
				email: "#{rows[1]}@gmail.com",
				pic: Faker::Avatar.image
		)
end

tweets = []
CSV.foreach("./seeds/tweets.csv") do |rows|
	break if rows[0].to_i > 30
	tweets.push(%W{ #{rows[0]}, #{rows[1]}, #{rows[2]} })
end

tweets.sort_by!{|tweet| tweet[2]}

tweets.each do |tweet|
	Tweet.create(user_id: tweet[0],
		text: tweet[1],
		created_at: tweet[2],
		updated_at: tweet[2]
	)
end

User.all.each do |user|
	rand(3..6).times do
		rand_user = User.find(rand(1..30))
		unless user == rand_user || user.following?(rand_user)
			user.follow(other_user)
		end
	end
end