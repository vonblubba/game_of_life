# frozen_string_literal: true

# Represents a single generation/iteration inside a world.
class CreateGenerations < ActiveRecord::Migration[6.1]
  def change
    create_table :generations do |t|
      t.string  :world, null: false
      t.text    :grid, null: false
      t.integer :iteration, null: false

      t.timestamps
    end

    add_index :generations, :world
    add_index :generations, :iteration
    add_index :generations, [:world, :iteration], unique: true
  end
end
