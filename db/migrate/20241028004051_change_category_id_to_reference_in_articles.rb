class ChangeCategoryIdToReferenceInArticles < ActiveRecord::Migration[7.2]
  def change
    # Add a new reference column with a foreign key
    add_reference :articles, :category, null: false, foreign_key: true
  end
end
