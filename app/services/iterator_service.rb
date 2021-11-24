# frozen_string_literal: true

class IteratorService
  attr_accessor(
    :file_content,
    :current_iteration,
    :current_world,
    :current_grid,
    :rows,
    :columns,
    :current_generation,
    :next_generation_grid,
    :next_generation
  )

  def initialize(file_path: nil, current_gen_id: nil)
    raise 'missing required param' unless file_path.present? || current_gen_id.present?
    raise "file #{file_path} not found" unless current_gen_id.present? || (file_path.present? && File.exist?(file_path))

    if current_gen_id.present?
      init_current_fields(current_gen_id: current_gen_id)
    else
      @current_world = Time.now.to_i.to_s
      @file_content = File.readlines(file_path).map(&:chomp)
      parse_input
      create_current_generation
    end
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

  def parse_input
    # some volidation on the file content would be required,
    # but in this context we are assuming input file content is valid

    @current_iteration = file_content.shift[/\d+/].to_i

    @rows, @columns = file_content.shift.split(' ')

    @current_grid = []

    file_content.each do |row|
      current_grid << row.split('').map { |e| e == '*' ? 1 : 0 }
    end
  end

  def create_current_generation
    @current_generation = Generation.create(
      world: current_world,
      iteration: current_iteration,
      grid: current_grid
    )
  end

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

  def init_current_fields(current_gen_id:)
    @current_generation = Generation.find(current_gen_id)
    @current_world = @current_generation.world
    @current_iteration = @current_generation.iteration
    @current_grid = @current_generation.grid
  end
end
