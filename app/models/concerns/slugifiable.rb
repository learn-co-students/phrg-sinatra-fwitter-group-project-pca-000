# frozen_string_literal: true

module Slugifiable
  module InstanceMethods
    def slug
      username.downcase.tr(" ", "-")
    end
  end

  module ClassMethods
    def find_by_slug(slug)
      all.detect { |a| a.slug == slug }
    end
  end
end
