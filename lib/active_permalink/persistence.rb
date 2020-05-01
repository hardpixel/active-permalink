module ActivePermalink
  module Persistence
    extend ActiveSupport::Concern

    included do
      before_validation on: :create do
        self.slug = slug
      end

      after_update do
        permalinks.reload
      end

      def slug=(value)
        Generator.generate(self, value)
      end
    end
  end
end
