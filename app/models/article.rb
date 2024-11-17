class Article < ApplicationRecord
  # Set up the relationship with Category model
  belongs_to :category
  # Set up the relationship with Comment model and sort them by created date
  # Delete associated comments when an article is deleted
  has_many :comments, -> { order(created_at: :desc) }, dependent: :destroy

  # These declarations enable a good bit of automatic behaviour. E.g., if you have an instance variable @article containing an article, you can retrieve all the comments belonging to that article as an array using @article.comments.
  validates :title, presence: true
  validates :source, presence: true
  validates :content, presence: true, length: { minimum: 10 }

  # Define scope for search * ->() is a lambda function, which takes one or more arguments to perform some logic
  # When Article.search(params[:search]) is called, the value of params[:search] is passed as keyword to the scope
  scope :search, ->(keyword) { where("LOWER(content) LIKE ?", "%#{keyword.downcase}%") }
end
