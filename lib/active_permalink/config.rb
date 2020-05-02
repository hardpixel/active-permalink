require 'active_support/configurable'

module ActivePermalink
  class Config
    include ActiveSupport::Configurable

    config_accessor(:class_name) { 'ActivePermalink::Permalink' }
    config_accessor(:querying) { true }
    config_accessor(:localized) { false }
    config_accessor(:locale_column) { :locale }
    config_accessor(:locale_accessors) { true }
    config_accessor(:fallbacks) { false }

    def options_for(**options)
      options.reverse_merge(
        class_name:       class_name,
        querying:         querying,
        localized:        localized,
        locale_column:    locale_column,
        locale_accessors: locale_accessors,
        fallbacks:        fallbacks
      )
    end
  end
end
