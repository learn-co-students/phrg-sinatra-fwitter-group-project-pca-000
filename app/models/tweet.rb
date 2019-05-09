# frozen_string_literal: true

class Tweet < ActiveRecord::Base
  belongs_to :user
end
