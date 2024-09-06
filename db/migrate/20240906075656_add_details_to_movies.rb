class AddDetailsToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :genre, :string
    add_column :movies, :cast, :text
    add_column :movies, :director, :string
  end
end
