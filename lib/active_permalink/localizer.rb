module ActivePermalink
  module Localizer
    extend ActiveSupport::Concern

    included do
      def permalink_reader
        PermalinkReader.new(permalinks, permalink_options)
      end

      def slug?
        permalink_reader.exists?
      end

      def slug
        permalink_reader.value
      end

      I18n.available_locales.each do |locale|
        define_method(:"slug_#{locale}?") do
          I18n.with_locale(locale) { slug? }
        end

        define_method(:"slug_#{locale}") do
          I18n.with_locale(locale) { slug }
        end

        define_method(:"slug_#{locale}=") do |value|
          I18n.with_locale(locale) { send(:slug=, value) }
        end
      end
    end

    class PermalinkReader
      attr_reader :permalinks, :options

      def initialize(permalinks, options)
        @permalinks = permalinks
        @options    = options
      end

      def fallbacks?
        options[:fallbacks].present?
      end

      def exists?
        find_permalink(I18n.locale).present?
      end

      def value
        find_slug(I18n.locale)
      end

      private

      def locale_column
        @options[:locale_column]
      end

      def find_permalink(locale)
        permalinks.find do |permalink|
          permalink.send(locale_column) == locale.to_s
        end
      end

      def find_fallback(locale)
        fallbacks = I18n.try(:fallbacks) || {}
        fallbacks = fallbacks.fetch(locale, [I18n.default_locale])
        permalink = nil

        fallbacks.find do |fallback|
          permalink = find_permalink(fallback)
          permalink.present?
        end

        permalink
      end

      def find_slug(locale)
        permalink = find_permalink(locale)
        permalink = find_fallback(locale) if permalink.blank?

        permalink.try(:slug)
      end
    end
  end
end
