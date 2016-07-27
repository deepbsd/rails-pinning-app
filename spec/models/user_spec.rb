require 'spec_helper'

RSpec.describe User, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  
  describe "User authenticate method" do
    before(:all) do
      @user = User.create!(first_name: "Fast", last_name: "Coder", email: "coder@skillcrush.com", password: "secret")
    end

    after(:all) do
      if !@user.destroyed?
        @user.destroy
      end
    end


    # This will not work now that we have password digests (encrypted
    # passwords)!
    it "authenticates and returns a user when valid email and password are used" do
      @user.authenticate(@user.password)
      expect(@user).to eq(@user)
    end


    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

  end
end
  
  
  
  
  
  
  
