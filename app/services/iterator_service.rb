# frozen_string_literal: true

class IteratorService
  attr_accessor(
    :current_iteration,
    :current_world,
    :current_grid,
    :rows,
    :columns,
    :current_generation,
    :next_generation_grid,
    :next_generation
  )

  def initialize(current_gen_id:)
    raise 'missing current_gen_id param' unless current_gen_id.present?

    @current_generation = Generation.find(current_gen_id)
    @current_world = @current_generation.world
    @current_iteration = @current_generation.iteration
    @current_grid = @current_generation.grid
  end

  def run
    calaculate_next_generation_grid
    create_next_generation

    {
      current_gen: current_generation,
      next_gen: next_generation
    }
  end

  private

  # steps

  def calaculate_next_generation_grid
    @next_generation_grid = []

    current_grid.each_with_index do |column, x_coordinate|
      next_gen_column = []

      column.each_with_index do |element, y_coordinate|
        next_gen_column << current_generation.next_gen_state(x_coordinate: x_coordinate, y_coordinate: y_coordinate)
      end

      next_generation_grid << next_gen_column
    end
  end

  def create_next_generation
    @next_generation = Generation.create(
      world: current_world,
      iteration: current_iteration + 1,
      grid: next_generation_grid
    )
  end
end
