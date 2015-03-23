require_relative '../main.rb'

describe "main" do
	it "should get a user" do
		user = User.find_by_username("ctaka")
		user["name"].should == "Chungyuk Takahashi"
		user["email"].should == "tachi6@brandeis.edu"
		user["password"].should == "password"
	end

	it "should return nil for a user not found" do
		User.find_by_name("PrinceofBelAir360noscope").should be_nil
	end

	it "should create a user" do
		user = User.create({
			:name => "123456",
			:username => "1234567",
			:email => "123456@gmail.com",
			:password => "123456"})
		user["name"].should == "123456"
		user["username"].should == "1234567"
		user["email"].should == "123456@gmail.com"
		user["password"].should == "123456"
		User.find_by_name("123456").should == user
	end

	it "should update a user" do
		user = User.find_by_name("123456")
		user.update_attributes({:username => "updated1234567"})
		user["username"].should == "updated1234567"
		User.find_by_name("123456").should == user
	end

	#it "should login user" do

	#end

end