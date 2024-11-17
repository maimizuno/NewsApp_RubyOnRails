class Category < ApplicationRecord
  #Set up the relationship with Article model and add scope to filter articles and sort them by the created date
  has_many :articles, -> { where(is_hidden: false).order(created_at: :desc) }
end