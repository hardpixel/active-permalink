require 'active_record'
require 'active_delegate'
require 'active_permalink/version'

module ActivePermalink
  extend ActiveSupport::Autoload

  autoload :Permalink
  autoload :Generator
  autoload :Persistence
  autoload :Localizer
  autoload :Querying
  autoload :Loader
  autoload :Config

  class << self
    def config
      @config ||= Config.new
    end

    def setup
      yield config
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include ActivePermalink::Loader
end
