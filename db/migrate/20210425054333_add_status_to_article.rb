class AddStatusToArticle < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :status, :interger
  end
end
