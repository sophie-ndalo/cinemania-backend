class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :image
      t.string :title
      t.text :description
      t.string :video
      t.integer :duration

      t.timestamps
    end
  end
end
