module ActivePermalink
  module Persistence
    extend ActiveSupport::Concern

    included do
      before_validation unless: :slug? do
        self.slug = nil
      end

      def slug=(value)
        generator = Generator.new(self, permalink_options)
        generator.generate(value)

        self.permalinks = generator.permalinks
      end
    end
  end
end
