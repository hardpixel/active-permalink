module ActivePermalink
  class Permalink < ActiveRecord::Base
    # Set table name
    self.table_name = 'permalinks'

    # Set default scope
    default_scope { order created_at: :desc }

    # Set custom scopes
    scope :global, -> { where scope: :global }

    # Belongs associations
    belongs_to :sluggable, polymorphic: true, optional: true
  end
end
