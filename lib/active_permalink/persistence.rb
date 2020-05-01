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

      def old_slugs
        @old_slugs ||= old_permalinks.pluck(:slug)
      end
    end
  end
end
