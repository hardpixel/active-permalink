module ActivePermalink
  class Generator
    def initialize(record, field, old_value, new_value, options={})
      @record    = record
      @field     = field
      @old_value = old_value
      @new_value = new_value
      @options   = options
      @scope     = options.fetch :scope, :global
    end

    def slug_candidates
      @new_value.present? ? @new_value : @record.send(@field)
    end

    def slug_from_column
      slug_candidates.to_slug.normalize.to_s
    end

    def deactivate_old_permalink
      unless @record.active_permalink.new_record?
        parameters = { slug: @old_value, active: true }
        permalink  = @record.old_permalinks.rewhere(parameters).first

        permalink.update_column(:active, false) unless permalink.nil?
      end
    end

    def reassign_old_permalink
      permalink = @record.old_permalinks.find_by(slug: slug_from_column)

      unless permalink.nil?
        permalink.update(active: true)
        permalink
      end
    end

    def build_new_permalink
      @record.build_active_permalink(slug: slug_from_column, scope: @scope, active: true)
    end

    def new_permalink
      deactivate_old_permalink
      @record.reload_active_permalink

      reassign_old_permalink || build_new_permalink
    end
  end
end
