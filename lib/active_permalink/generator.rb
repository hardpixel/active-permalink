require 'any_ascii'

module ActivePermalink
  class Generator
    class << self
      def generate(record, value, locale = nil, raw: false)
        return if value.nil? && !record.slug_should_generate?

        options   = record.permalink_options.merge(locale: locale, raw: raw)
        generator = Generator.new(record, options)
        generator.generate(value)

        record.permalinks = generator.permalinks
      end
    end

    def initialize(record, options = {})
      options[:locale] = options.fetch(:locale, I18n.locale).to_s

      @record  = record
      @options = options
      @field   = options[:field]
      @scope   = options.fetch(:scope, :global)
    end

    def generate(new_value)
      @new_value = new_value
      return unless changed?

      deactivate_active_permalink
      assign_active_permalink
    end

    def permalinks
      @permalinks ||= @record.permalinks
    end

    private

    def locale
      @options[:locale]
    end

    def changed?
      @new_value.blank? || @new_value != active_permalink.try(:slug)
    end

    def localized?
      @options[:localized].present?
    end

    def locale_column
      @options[:locale_column]
    end

    def exists?(slug)
      params = localize(scope: @scope, slug: slug)
      Permalink.where(params).count.zero?
    end

    def localize(**params)
      params[locale_column] = locale if localized?
      params
    end

    def available_permalinks
      if localized?
        permalinks.select { |item| item.send(locale_column) == locale }
      else
        permalinks
      end
    end

    def active_permalink
      available_permalinks.find { |item| item.active == true }
    end

    def build_permalink
      params = localize(scope: @scope, active: true)
      active_permalink || permalinks.build(params)
    end

    def old_permalink
      params = localize(slug: slug_from_column)

      available_permalinks.find do |item|
        params.all? { |key, value| item.send(key) == value }
      end
    end

    def slug_from_column
      @slug_from_column ||= begin
        value = @new_value.presence || @record.send(@field)
        return if value.blank?

        return value if @options[:raw] == true

        value = AnyAscii.transliterate(value)
        value.parameterize
      end
    end

    def scope_unique_slug
      unique = slug_from_column
      index  = 1

      while not exists?(unique)
        unique = "#{slug_from_column}-#{(index += 1)}"
      end

      unique
    end

    def deactivate_active_permalink
      available_permalinks.each do |item|
        item.active = false unless item.new_record?
      end
    end

    def assign_active_permalink
      if old_permalink
        old_permalink.write_attribute(:active, true)
      else
        build_permalink.write_attribute(:slug, scope_unique_slug)
      end
    end
  end
end
