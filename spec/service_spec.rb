ENV['RACK_ENV'] = 'test'

require 'pry'
require 'rspec'
require 'rack/test'
require_relative '../api_service.rb'

set :environment, :test

describe "service" do
	include Rack::Test::Methods

  def app 
    Sinatra::Application
  end

  before(:all) do 
    User.create(name: "Pito",
          username: "psalas",
          password: "password",
          email: "ps@brandeis.edu"
    )
    user = User.find_by_username("psalas")
    Tweet.create(text: "test tweet", user_id: user.id)
  end

  it "should return a user by username" do
    get '/api/v1/users/psalas' 
    last_response.should be_ok
    attributes = JSON.parse(last_response.body) 
    attributes["name"].should == "Pito"
    attributes["username"].should == "psalas"
    attributes["email"].should == "ps@brandeis.edu"
  end

  it "should return the tweets of a user" do
    get '/api/v1/users/psalas/tweets' 
    last_response.should be_ok
    attributes = JSON.parse(last_response.body) 
    attributes.first["text"].should == "test tweet"
  end 

  it "should return a tweet based on the id" do
    get "/api/v1/tweets/#{Tweet.all.count}"
    last_response.should be_ok
    attributes = JSON.parse(last_response.body) 
    attributes["text"].should == "test tweet"
  end

  it "should return the most recent tweets" do
  	get '/api/v1/tweets/recent/5'
  	last_response.should be_ok
	  attributes = JSON.parse(last_response.body)
    attributes[0]["text"].should == "test tweet"
  end

	# it "should return the comments of a user" do
	# 	get '/api/v1/users/:id/comments'
	# 	last_response.should be_ok
	# 	attributes = JSON.parse(last_response.body)
	# 	attributes.should == nil
	# end
end