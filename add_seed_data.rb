require 'json'
require 'sinatra'
require 'active_record'
require "sinatra/activerecord"
require 'pry'
require './main.rb'
require 'faker'
require './config/environments'
require './models/user'
require './models/tweet'

count = 0

(0..100).each do
	name = Faker::Name.name
	random_char = (33 + rand(93)).chr
	user = User.create(name: name,
				username: Faker::Internet.user_name(name, %W(. _ - #{random_char})),
				password: Faker::Internet.password(6, 20),
				email: Faker::Internet.free_email,
				pic: Faker::Avatar.image
				)

	tweets_count = 0
	tweet_limit = (7 + rand(13))

	while(tweets_count <= tweet_limit) do

		case rand(4)
		when 0
			Tweet.create(text: Faker::Hacker.say_something_smart,
						user_id: user.id)
		when 1
			Tweet.create(text: Faker::Lorem.sentence,
						user_id: user.id)
		when 2
			Tweet.create(text: Faker::Company.bs,
						user_id: user.id)
		when 3
			Tweet.create(text: Faker::Company.catch_phrase,
						user_id: user.id)
		when 4
			Tweet.create(text: Faker::Hacker.say_something_smart,
						user_id: user.id)
		else
			Tweet.create(text: Faker::Hacker.say_something_smart,
						user_id: user.id)
		end
		tweets_count += 1
	end

end

User.all.each do |user|
	current_user = user
	num_of_following = 20 + rand(7)
	(0..num_of_following).each do
		other_user = User.find(1 + rand(100))
		if other_user
			unless current_user.following?(other_user)
				current_user.follow(other_user)
			end
		end
	end
end