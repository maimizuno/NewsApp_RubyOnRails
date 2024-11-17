class Comment < ApplicationRecord
  #Set up the relationship with Article model
  belongs_to :article
end
