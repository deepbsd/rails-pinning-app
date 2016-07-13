class User < ActiveRecord::Base

  def self.authenticate(email, password)
    @user = User.find_by_email(email)
    if not @user.nil?

      if @user.password == password
        return @user
      end

    end
    return nil

  end


end
