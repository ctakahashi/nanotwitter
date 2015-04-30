require 'resque'

class UpdateFollowerFeeds
  @queue = :update_follower_feeds

  def self.perform(args)
    tweet = args[:tweet]
    user = User.find(tweet.user_id)

    $redis.lpush("home_page_feed", {:text => tweet.text,
                  :created_at => tweet.created_at,
                  :username => user.username,
                  :pic => user.pic}.to_json)
    $redis.rpop("home_page_feed")

    leading_list = $redis.lrange("l#{user.id}", 0, -1)
    leading_list.each do |follower|
      $redis.lpush("f#{follower}", tweet.id)
      $redis.rpop("f#{follower}")
    end

  end

end