require 'spec_helper'

describe User do

	before do
		@user = User.new(name: "Example User", email: "user@example.com",
						password: "foobar", password_confirmation: "foobar")
	end

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:authenticate) }

	it { should be_valid }

	describe "when name it not present" do
		before { @user.name = " " }
		it { should_not be_valid }
	end

	describe "when email it not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "a"*51 }
		it { should_not be_valid }
	end

	describe "when the email format is invalid" do
		it "should be valid" do
			addresses = %w[user@foo,com user_at_foo.org example@foo_foo.com 
							foo@foo+bar.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				expect(@user).not_to be_valid
			end
		end
	end

	describe "when the email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM user@f.b.org first.last@foo.jp 
							a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				expect(@user).to be_valid
			end
		end
	end

	describe "when the email address is already taken" do
		before do
			user_with_same_email = @user.dup
		   	user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "when the password is not present" do
		before do
			@user = User.new(name: "Example User", email: "user@example.com",
							password: " ", password_confirmation: " ")
		end
		it { should_not be_valid }
	end

	describe "when the password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	# start here

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end

	describe "return value of authentication method" do
		before { @user.save }
		let(:found_user) { User.find_by(email: @user.email) }

		describe "with valid password" do
			it { should eq found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }

			it { should_not eq user_for_invalid_password }
			specify { expect(user_for_invalid_password).to be_false }
		end
	end

	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
		# is equivalent to it { expect_to(@user.remember_token).not_to be_blank }
	end
end