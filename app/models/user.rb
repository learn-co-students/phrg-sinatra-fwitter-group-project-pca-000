# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :tweets
  has_secure_password

  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true

  def slug
    username.downcase.tr(" ", "-")
  end

  def self.find_by_slug(slug)
    User.find { |user| user.slug == slug }
  end
end
