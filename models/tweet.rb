class Tweet < ActiveRecord::Base
	belongs_to 	:user
	has_many 	:retweets
	has_many    :comments
	def self.search(search)
		# search=User.where(name: "ctaka").id
	  where("text LIKE ?", "%#{search}%")
	end
end