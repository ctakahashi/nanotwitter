require 'rspec'
require 'rack/test'
require_relative '../service.rb'

describe "service" do
	include Rack::Test::Methods

  def app 
    Sinatra::Application
  end

  it "should return a user by id" do
    get '/api/v1/users/1' 
    last_response.should be_ok
    attributes = JSON.parse(last_response.body) 
    attributes["name"].should == "Chungyuk Takahashi"
  end

  it "should return the tweets of a user" do
    get '/api/v1/users/1/tweets' 
    last_response.should be_ok
    attributes = JSON.parse(last_response.body) 
    attributes.first["text"].should == "The first nano tweet"
  end 

  it "should return a tweet based on the id" do
    get '/api/v1/tweets/1' 
    last_response.should be_ok
    attributes = JSON.parse(last_response.body) 
    attributes["text"].should == "The first nano tweet"
  end

  it "should return the most recent tweets" do
  	get '/api/v1/tweets/recent/5'
  	last_response.should be_ok
	  attributes = JSON.parse(last_response.body)
    attributes[0]["id"].should == Tweet.all.count + 20072
  end

	# it "should return the comments of a user" do
	# 	get '/api/v1/users/:id/comments'
	# 	last_response.should be_ok
	# 	attributes = JSON.parse(last_response.body)
	# 	attributes.should == nil
	# end
end