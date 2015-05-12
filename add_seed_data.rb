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
		if rows[0]
		user = User.create(name: rows[1],
				username: rows[1],
				password: Faker::Internet.password(6, 20),
				email: "#{rows[1]}@gmail.com",
				pic: Faker::Avatar.image
		)
end

tweets = []
CSV.foreach("./seeds/tweets.csv") do |rows|
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

CSV.foreach("./seeds/follows.csv") do |rows|
	current_user = User.find(rows[0])
	other_user = User.find(rows[1])
	current_user.follow(other_user)
end