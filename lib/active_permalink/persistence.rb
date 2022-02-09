module ActivePermalink
  module Persistence
    extend ActiveSupport::Concern

    included do
      include ActiveDelegate

      delegate_attribute :slug, :string,
        to: :active_permalink

      before_validation :slug_should_generate!,
        on: [:create, :update],
        if: :slug_needs_generate?

      def raw_slug=(value)
        _generate_permalink_slug(value, raw: true)
      end

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

      def slug_needs_generate?
        !slug? && send(:"#{permalink_options[:field]}_changed?")
      end

      def slug_should_generate!
        @slug_should_generate = true
        _generate_permalink_slug(self[:slug])
      ensure
        @slug_should_generate = false
      end

      def _generate_permalink_slug(value, **options)
        Generator.generate(self, value, **options)
      end
    end
  end
end
