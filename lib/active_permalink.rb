require 'active_record'
require 'active_delegate'
require 'babosa'
require 'active_permalink/version'

module ActivePermalink
  extend ActiveSupport::Autoload

  # Autoload base modules
  autoload :Permalink
  autoload :Generator
  autoload :Sluggable
  autoload :Loader
end

ActiveSupport.on_load(:active_record) do
  include ActivePermalink::Loader
end
