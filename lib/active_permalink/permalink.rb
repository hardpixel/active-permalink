module ActivePermalink
  class Permalink < ActiveRecord::Base
    self.table_name = 'permalinks'

    default_scope { order created_at: :desc }

    scope :global, -> { where scope: :global }

    belongs_to :sluggable, polymorphic: true, optional: true
  end
end
