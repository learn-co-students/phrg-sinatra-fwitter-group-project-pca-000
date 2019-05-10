# frozen_string_literal: true

require "bcrypt"

class User < ActiveRecord::Base
  include BCrypt

  has_secure_password
  has_many :tweets

  def slug
    username.downcase.tr(" ", "-")
  end

  def self.find_by_slug(slug)
    User.all.find { |user| user.slug == slug }
  end

  def self.authenticate(params)
    user = User.find_by_name(params[:username])
    user && user.password == params[:password] ? user : nil
  end
end
