require 'active_record'
require 'active_delegate'
require 'babosa'
require 'active_permalink/version'

module ActivePermalink
  extend ActiveSupport::Autoload

  # Autoload base modules
  autoload :Config
  autoload :Permalink
  autoload :Generator
  autoload :Sluggable
  autoload :Loader

  # Set attr accessors
  mattr_accessor :config

  # Set config options
  @@config = {}

  # Setup module
  def self.setup
    yield config
  end
end

ActiveSupport.on_load(:active_record) do
  include ActivePermalink::Loader
end
