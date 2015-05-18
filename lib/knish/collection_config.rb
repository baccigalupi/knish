module Knish
  class CollectionConfig < Struct.new(:config, :path)
    extend Forwardable

    def next
      (existing_ids.max || 0) + 1
    end

    def root
      "#{config.root}/#{path}"
    end

    def_delegators :config, :view_to_db_path, :db_name, :data_filename

    private

    def existing_ids
      Dir.glob("#{root}/*").map{|d| d.split('/').last.to_i }
    end
  end
end
