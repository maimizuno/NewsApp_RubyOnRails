class CreateArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.integer :category_id
      t.text :source
      t.boolean :is_hidden

      t.timestamps
    end
  end
end
