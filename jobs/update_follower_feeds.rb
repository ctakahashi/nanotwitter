require 'resque'

class UpdateFollowerFeeds
  @queue = :update_follower_feeds

  def self.perform(args)
    tweet = args[:tweet_id]
    user = args[:user_id]
    followers_list = $redis.lrange(user, 0, -1)
    followers_list.each do |follower|
      $redis.lpush(follower, tweet.id)
      $redis.rpop
    end
  end

end