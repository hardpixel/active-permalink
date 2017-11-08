require 'active_record'
require 'active_delegate'
require 'active_permalink/version'

module ActivePermalink
  class << self
    def setup(&block)
      yield
    end
  end
end
