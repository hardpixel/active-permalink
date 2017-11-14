module ActivePermalink
  module Sluggable
    extend ActiveSupport::Concern

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

    def found_by_slug
      @found_by_slug
    end

    def found_by_slug=(value)
      @found_by_slug = value
    end

    def found_by_slug?
      !found_by_slug.nil?
    end

    def needs_redirect?
      found_by_slug? and found_by_slug != slug
    end

    def old_slugs
      @old_slugs ||= old_permalinks.pluck(:slug)
    end
  end
end
