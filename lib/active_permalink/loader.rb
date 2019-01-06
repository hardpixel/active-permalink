module ActivePermalink
  module Loader
    extend ActiveSupport::Concern

    class_methods do
      def has_permalink(field, options={})
        include ActiveDelegate
        include Querying

        assoc_opts = { as: :sluggable, class_name: 'ActivePermalink::Permalink', dependent: :destroy }
        has_many :permalinks, assoc_opts
        has_many :old_permalinks, -> { where active: false }, assoc_opts

        has_one :active_permalink, -> { where active: true }, assoc_opts.merge(autosave: true)
        delegate_attribute :slug, :string, to: :active_permalink

        before_save do |record|
          if slug.blank? or slug_changed?
            premalink_generator   = Generator.new(record, field, slug_was, slug, options)
            self.active_permalink = premalink_generator.new_permalink
          end
        end
      end
    end
  end
end
