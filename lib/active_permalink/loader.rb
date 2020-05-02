module ActivePermalink
  module Loader
    extend ActiveSupport::Concern

    class_methods do
      def has_permalink(field, **options)
        options = ActivePermalink.config.options_for(field: field, **options)

        class_attribute :permalink_options
        self.permalink_options = options

        with_options(as: :sluggable, class_name: options[:class_name]) do
          has_many :permalinks,
            dependent: :destroy,
            autosave: true

          has_many :old_permalinks,
            -> { inactive }

          if options[:localized]
            has_many :active_permalinks,
              -> { active }

            has_one :active_permalink,
              -> { active.where(options[:locale_column] => I18n.locale) }
          else
            has_one :active_permalink,
              -> { active }
          end
        end

        include Persistence

        include Querying  if options[:querying]
        include Localizer if options[:localized]
      end
    end
  end
end
