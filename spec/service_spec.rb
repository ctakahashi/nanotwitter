require 'rspec'
require 'rack/test'
require_relative '../service.rb'

describe "service" do
	include Rack::Test::Methods

  def app 
    Sinatra::Application
  end

  describe "GET on /api/v1/users/:id" do

    it "should return a user by id" do
      get '/api/v1/users/1' 
      last_response.should be_ok
      attributes = JSON.parse(last_response.body) 
      attributes["id"].should == User.find(1).id
    end

    it "should return a user by name" do
      get '/api/v1/users/1' 
      last_response.should be_ok
      attributes = JSON.parse(last_response.body) 
      attributes["name"].should == User.find(1).name
    end

    it "should return a user by username" do
      get '/api/v1/users/1' 
      last_response.should be_ok
      attributes = JSON.parse(last_response.body) 
      attributes["username"].should == User.find(1).username
    end

    it "should return a user by password" do
      get '/api/v1/users/1' 
      last_response.should be_ok
      attributes = JSON.parse(last_response.body) 
      attributes["password"].should == User.find(1).password
    end

    it "should return a user by pic" do
      get '/api/v1/users/1' 
      last_response.should be_ok
      attributes = JSON.parse(last_response.body) 
      attributes["pic"].should == User.find(1).pic
    end

  end

  it "should return the tweets of a user" do
    get '/api/v1/users/1/tweets' 
    last_response.should be_ok
    attributes = JSON.parse(last_response.body) 
    attributes.first["text"].should == Tweet.first.text
  end 

  it "should return a tweet based on the id" do
    get '/api/v1/tweets/1' 
    last_response.should be_ok
    attributes = JSON.parse(last_response.body) 
    attributes["text"].should == "drive transparent schemas"
  end

  it "should return the most recent tweets" do
  	get '/api/v1/tweets/recent/5'
  	last_response.should be_ok
	  attributes = JSON.parse(last_response.body)
    attributes[0]["id"].should == Tweet.all.count
  end

	# it "should return the comments of a user" do
	# 	get '/api/v1/users/:id/comments'
	# 	last_response.should be_ok
	# 	attributes = JSON.parse(last_response.body)
	# 	attributes.should == nil
	# end
end