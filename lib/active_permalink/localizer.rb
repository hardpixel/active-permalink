module ActivePermalink
  module Localizer
    extend ActiveSupport::Concern

    included do
      def slug_backend
        @slug_backend ||= PermalinkBackend.new(self)
      end

      alias permalink_reader slug_backend

      def slug?(locale: nil)
        slug_backend.exists?(locale || I18n.locale)
      end

      def slug(locale: nil)
        slug_backend.read(locale || I18n.locale)
      end

      def slug=(value, locale: nil)
        slug_backend.write(value, locale || I18n.locale)
      end

      if permalink_options[:locale_accessors]
        include SlugLocaleAccessors
      end

      private

      def _generate_permalink_slug(value)
        slug_backend.write(value, I18n.locale)
      end
    end

    class PermalinkBackend
      attr_reader :record, :permalinks, :options

      def initialize(record)
        @record     = record
        @options    = record.permalink_options
        @permalinks = record.permalinks.to_a
      end

      def fallbacks?
        options[:fallbacks].present?
      end

      def exists?(locale)
        find_permalink(locale).present?
      end

      def read(locale)
        find_slug(locale)
      end

      def write(value, locale)
        update_slug(value, locale)
      end

      private

      def locale_column
        @options[:locale_column]
      end

      def find_permalink(*locales)
        permalinks.select(&:active?).find do |permalink|
          locale = permalink.send(locale_column)
          locales.include?(locale.to_sym)
        end
      end

      def find_fallback(locale)
        locales = I18n.fallbacks[locale]
        find_permalink(*locales) if locales.present?
      end

      def find_slug(locale)
        permalink = find_permalink(locale)
        permalink = find_fallback(locale) if permalink.blank?

        permalink.try(:slug)
      end

      def update_slug(value, locale)
        Generator.generate(record, value, locale)
        @permalinks = record.permalinks.to_a
      end
    end

    module SlugLocaleAccessors
      extend ActiveSupport::Concern

      included do
        I18n.available_locales.each do |locale|
          define_method(:"slug_#{locale}?") do
            slug_backend.exists?(locale)
          end

          define_method(:"slug_#{locale}") do
            slug_backend.read(locale)
          end

          define_method(:"slug_#{locale}=") do |value|
            slug_backend.write(value, locale)
          end
        end
      end
    end
  end
end
