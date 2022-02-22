module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      results = self.where(nil)
      # filtering_params.each do |value|
      #   puts "------this is value-------"
      #   puts value
      #   results = results.public_send("filter_by_rating", value) if value.present?
      # end
      # results
      
      results = results.public_send("filter_by_rating", filtering_params) if filtering_params.present?
    end
  end
end