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

  def initialize(file_path:)
    raise "file #{file_path} not found" unless File.exist? file_path

    @file_content = File.readlines(file_path).map(&:chomp)
    @current_world = Time.now.to_i.to_s
  end

  def run
    parse_input
    create_current_generation
    calaculate_next_generation_grid
    create_next_generation
    generate_output
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

  def generate_output
    generation_text = "Generation #{next_generation.iteration}:"
    size_text = [rows, columns].join(' ')
    grid_text = serialize_grid(grid: next_generation.grid)
    [generation_text, size_text, grid_text].join("\n")
  end

  # utility methods

  def serialize_grid(grid:)
    grid.map { |a| a.join('') }.join("\n").gsub('0', '.').gsub('1', '*')
  end
end
