class User < ActiveRecord::Base
	validates_uniqueness_of :name, :email, :username
	def to_json
		super(:except => :password)
	end

	has_many :tweets
	has_many :comments

	has_many :follower_bonds, class_name: "Bond", foreign_key: "follower_id", dependent: :destroy
	has_many :following, through: :follower_bonds, source: :leader

	has_many :leader_bonds,  class_name: "Bond", foreign_key: "leader_id", dependent: :destroy
	has_many :leading, through: :leader_bonds, source: :follower

	def follow(other_user)
		follower_bonds.create(leader_id: other_user.id)
		other_user.leader_bonds.create(follower_id: :id)
	end

	def unfollow(other_user)
		follower_bonds.find_by(leader_id: other_user.id).destroy
		other_user.leader_bonds.find_by(follower_id: :id).destroy
	end

	def following?(other_user)
		following.include?(other_user)
	end

end