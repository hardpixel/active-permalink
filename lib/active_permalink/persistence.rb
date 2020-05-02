module ActivePermalink
  module Persistence
    extend ActiveSupport::Concern

    included do
      before_validation :slug_should_generate!,
        on: [:create, :update],
        unless: :slug?

      def slug=(value)
        _generate_permalink_slug(value)
      end

      def old_slugs
        @old_slugs ||= old_permalinks.pluck(:slug)
      end

      def slug_should_generate?
        @slug_should_generate == true
      end

      private

      def slug_should_generate!
        @slug_should_generate = true
        _generate_permalink_slug(self[:slug])
      ensure
        @slug_should_generate = false
      end

      def _generate_permalink_slug(value)
        Generator.generate(self, value)
      end
    end
  end
end
