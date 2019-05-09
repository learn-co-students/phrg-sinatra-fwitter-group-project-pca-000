# frozen_string_literal: true

class User < ActiveRecord::Base
  has_secure_password
  has_many :tweets

  def slug
    username.downcase.tr(" ", "-")
  end

  def self.find_by_slug(slug)
    User.all.each do |user|
      return user if user.slug == slug
    end
  end
end
