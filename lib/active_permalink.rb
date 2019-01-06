require 'stringex'
require 'active_record'
require 'active_delegate'
require 'active_permalink/version'

module ActivePermalink
  extend ActiveSupport::Autoload

  # Autoload base modules
  autoload :Permalink
  autoload :Generator
  autoload :Querying
  autoload :Loader
end

ActiveSupport.on_load(:active_record) do
  include ActivePermalink::Loader
end
