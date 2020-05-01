module ActivePermalink
  class Permalink < ActiveRecord::Base
    self.table_name = 'permalinks'

    scope :global,   -> { where scope: :global }
    scope :active,   -> { where active: true }
    scope :inactive, -> { where active: false }

    belongs_to :sluggable, polymorphic: true, optional: true
  end
end
