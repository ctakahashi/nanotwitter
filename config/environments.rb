# These Settings Establish the Proper Database Connection for Heroku Postgres
# The environment variable DATABASE_URL should be in the following format:
#     => postgres://{user}:{password}@{host}:{port}/path
# This is automatically configured on Heroku, you only need to worry if you also
# want to run your app locally

ENV["REDISTOGO_URL"] = 'redis://redistogo:ad7a0f5c567b8f49d79130cff7439705@slimehead.redistogo.com:9032/'
ENV["REDISCLOUD_URL"] = 'redis://rediscloud:OPd06SvVN0d0NEVw@pub-redis-15976.us-east-1-4.1.ec2.garantiadata.com:15976/'

configure :production do
  puts "[production environment]"
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

  # require 'redis'
  # uri = URI.parse(ENV['REDISTOGO_URL'])
  # REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  require 'redis'
  uri = URI.parse(ENV["REDISCLOUD_URL"])
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

  ActiveRecord::Base.establish_connection(
      :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8',
      :pool => 16
  )
end

configure :development, :test do
  puts "[develoment or test Environment]"

  # require 'redis'
  # uri = URI.parse(ENV['REDISTOGO_URL'])
  # REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  require 'redis'
  uri = URI.parse(ENV["REDISCLOUD_URL"])
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

end