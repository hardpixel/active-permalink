module ActivePermalink
  module Persistence
    extend ActiveSupport::Concern

    included do
      before_validation on: :create do
        self.slug = slug
      end

      after_update do
        permalinks.reload
      end

      def slug=(value)
        generator = Generator.new(self, permalink_options)
        generator.generate(value)

        self.permalinks = generator.permalinks
      end
    end
  end
end
