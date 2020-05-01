module ActivePermalink
  module Loader
    extend ActiveSupport::Concern

    class_methods do
      def has_permalink(field, querying: true, localized: false, locale_column: :locale, **options)
        include ActiveDelegate

        class_attribute :permalink_options

        self.permalink_options = options.reverse_merge(
          field:            field,
          querying:         querying,
          localized:        localized,
          locale_column:    locale_column,
          locale_accessors: true
        )

        with_options(as: :sluggable, class_name: 'ActivePermalink::Permalink') do
          has_many :permalinks,
            dependent: :destroy,
            autosave: true

          has_many :old_permalinks,
            -> { inactive }

          if localized
            has_many :active_permalinks,
              -> { active }

            has_one :active_permalink,
              -> { active.where(locale_column => I18n.locale) }
          else
            has_one :active_permalink,
              -> { active }
          end
        end

        delegate_attribute :slug, :string,
          to: :active_permalink

        include Persistence

        include Querying  if querying
        include Localizer if localized
      end
    end
  end
end
