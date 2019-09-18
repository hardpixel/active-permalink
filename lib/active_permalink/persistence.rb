module ActivePermalink
  module Persistence
    extend ActiveSupport::Concern

    included do
      def slug=(value)
        generator = Generator.new(self, permalink_options)
        generator.generate(value)

        self.permalinks = generator.permalinks
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
  end
end
