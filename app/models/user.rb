require 'bcrypt'

class User < ActiveRecord::Base

  include BCrypt

  has_secure_password
  has_many :tweets

  def self.authenticate(params)
    user = User.find_by_name(params[:username])
    (user && user.password == params[:password]) ? user : nil
  end
end
