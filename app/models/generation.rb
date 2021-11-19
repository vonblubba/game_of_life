# frozen_string_literal: true

# == Schema Information
#
# Table name: generations
#
#  id         :integer          not null, primary key
#  grid       :text             not null
#  iteration  :integer          not null
#  world      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_generations_on_iteration            (iteration)
#  index_generations_on_world                (world)
#  index_generations_on_world_and_iteration  (world,iteration) UNIQUE
#
class Generation < ApplicationRecord
  serialize :grid

  validates :grid, presence: true
  validates :iteration, presence: true
  validates :world, presence: true
  validates :iteration, uniqueness: { scope: :world }

  def next_gen_state(x_coordinate:, y_coordinate:)
    check_bounds(x_coordinate: x_coordinate, y_coordinate: y_coordinate)

    current_state = grid[x_coordinate][y_coordinate]
    neighs = neighbours(x_coordinate: x_coordinate, y_coordinate: y_coordinate)

    alive_neighs = neighs.compact&.sum

    if current_state == 1
      alive_neighs < 2 || alive_neighs > 3 ? 0 : 1
    else
      alive_neighs == 3 ? 1 : 0
    end
  end

  def neighbours(x_coordinate:, y_coordinate:)
    check_bounds(x_coordinate: x_coordinate, y_coordinate: y_coordinate)

    # brutal but effective :-)
    result = []

    neighs = [
      [x_coordinate - 1, y_coordinate - 1],
      [x_coordinate - 1, y_coordinate],
      [x_coordinate - 1, y_coordinate + 1],
      [x_coordinate, y_coordinate - 1],
      [x_coordinate, y_coordinate + 1],
      [x_coordinate + 1, y_coordinate - 1],
      [x_coordinate + 1, y_coordinate],
      [x_coordinate + 1, y_coordinate + 1]
    ]

    neighs.each do |n|
      result << grid[n[0]][n[1]] if in_bounds?(x_coordinate: n[0], y_coordinate: n[1])
    end

    result
  end

  private

  def in_bounds?(x_coordinate:, y_coordinate:)
    x_coordinate >= 0 && x_coordinate < grid.count && y_coordinate >= 0 && y_coordinate < grid[0].count
  end

  def check_bounds(x_coordinate:, y_coordinate:)
    raise 'x_coordinate out of bounds' unless x_coordinate >= 0 && x_coordinate < grid.count
    raise 'y_coordinate out of bounds' unless y_coordinate >= 0 && y_coordinate < grid[0]&.count
  end
end
