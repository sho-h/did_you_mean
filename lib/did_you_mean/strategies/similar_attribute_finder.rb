module DidYouMean
  class SimilarAttributeFinder < BaseFinder
    attr_reader :columns, :attribute_name

    def initialize(exception)
      @columns        = exception.frame_binding.eval("self.class").columns
      @attribute_name = exception.original_message.gsub("unknown attribute: ", "")
    end

    def words
      columns.map(&:name)
    end

    alias similar_attributes similar_words
    alias target_word attribute_name

    def format(column_name)
      "%{column}: %{type}" % {
        column: column_name,
        type:   columns.detect{|c| c.name == column_name }.type
      }
    end
  end

  strategies["ActiveRecord::UnknownAttributeError"] = SimilarAttributeFinder
end
