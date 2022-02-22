class Movie < ActiveRecord::Base
    include Filterable
    
    scope :filter_by_rating, -> (rating) {where rating: rating}
end