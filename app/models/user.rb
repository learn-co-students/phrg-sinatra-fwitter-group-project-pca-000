class User < ActiveRecord::Base
  has_many :tweets

  def self.authenticate(params)
    user = User.find_by_name(params[:username])
    (user && user.password == params[:password]) ? user : nil
  end
end
