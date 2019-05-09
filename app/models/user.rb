# frozen_string_literal: true

require_relative "./concerns/slugifiable.rb"

class User < ActiveRecord::Base
  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true
  has_secure_password
  has_many :tweets

  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods
end
