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
  end

  it "should return a user by id" do
    get '/api/v1/users/1' 
    last_response.should be_ok
    attributes = JSON.parse(last_response.body) 
    attributes["name"].should == User.find(1).name
  end

  it "should return the tweets of a user" do
    get '/api/v1/users/1/tweets' 
    last_response.should be_ok
    attributes = JSON.parse(last_response.body) 
    attributes.first["text"].should == User.find(1).tweets.first.text
  end 

  it "should return a tweet based on the id" do
    get '/api/v1/tweets/1' 
    last_response.should be_ok
    attributes = JSON.parse(last_response.body) 
    attributes["text"].should == Tweet.find(1).text
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