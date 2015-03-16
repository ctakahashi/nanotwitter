class Tweet < ActiveRecord::Base
	belongs_to 	:user
	has_many 	:retweets
	has_many    :comments
end