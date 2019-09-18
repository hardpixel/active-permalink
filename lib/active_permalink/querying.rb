module ActivePermalink
  module Querying
    extend ActiveSupport::Concern

    class_methods do
      def permalink_locator
        PermalinkLocator.new(self, permalink_options)
      end

      def with_slug(*args)
        permalink_locator.scope(*args)
      end

      def find_by_slug(*args)
        permalink_locator.locate(*args)
      end

      def find_by_slug!(*args)
        permalink_locator.locate!(*args)
      end
    end

    def found_by_slug
      @found_by_slug
    end

    def found_by_slug=(value)
      @found_by_slug = value
    end

    def found_by_slug?
      found_by_slug.present?
    end

    def needs_redirect?
      found_by_slug? && found_by_slug != slug
    end

    def old_slugs
      @old_slugs ||= old_permalinks.pluck(:slug)
    end

    class PermalinkLocator
      attr_reader :model, :options

      def initialize(model, options)
        @model   = model
        @options = options
      end

      def scope(value, locale: nil)
        params = localize(slug: value, locale: locale)
        model.includes(:permalinks).where(permalinks: params)
      end

      def locate(*args)
        find_record(:find_by, *args)
      end

      def locate!(*args)
        find_record(:find_by!, *args)
      end

      private

      def localized?
        options[:localized].present?
      end

      def locale_column
        options[:locale_column]
      end

      def localize(locale: nil, **params)
        params[locale_column] = (locale || I18n.locale) if localized?
        params
      end

      def find_record(method, value, locale: nil)
        params = localize(slug: value, locale: locale)
        record = model.includes(:permalinks).send(method, permalinks: params)

        record.found_by_slug = value if record.present?
        record
      end
    end
  end
end
