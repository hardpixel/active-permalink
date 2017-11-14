module ActivePermalink
  module Sluggable
    extend ActiveSupport::Concern

    included do
      attribute :found_by_slug, :string
    end

    class_methods do
      def find_by_slug(value)
        _find_by_permalinks_slug(value)
      end

      def find_by_slug!(value)
        _find_by_permalinks_slug(value, true)
      end

      private

        def _find_by_permalinks_slug(value, raise_error=false)
          method = raise_error ? :find_by! : :find_by
          record = includes(:permalinks).send(method, permalinks: { slug: value })

          unless record.nil?
            record.found_by_slug = value
          end

          record
        end
    end

    def needs_redirect?
      found_by_slug != slug if found_by_slug?
    end

    def old_slugs
      @old_slugs ||= old_permalinks.pluck(:slug)
    end
  end
end
