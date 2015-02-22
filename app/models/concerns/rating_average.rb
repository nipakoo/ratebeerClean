module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    if ratings.count > 0
      ratings.map(&:score).sum.to_f/ratings.count
    else
      0
    end
  end
end