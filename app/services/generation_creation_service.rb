# frozen_string_literal: true

class GenerationCreationService
  attr_accessor :file_path, :file_content, :generation, :current_iteration, :current_grid

  def initialize(file_path:)
    @file_path = file_path
  end

  def run
    read_file_content
    parse_file_content
    create_generation

    generation
  end

  private

  def read_file_content
    raise "file #{file_path} not found" unless File.exist?(file_path)

    @file_content = File.readlines(@file_path).map(&:chomp)
  end

  def parse_file_content
    # some volidation on the file content would be required,
    # but in this context we are assuming input file content is valid

    @current_iteration = file_content.shift[/\d+/].to_i

    @rows, @columns = file_content.shift.split(' ')

    @current_grid = []

    file_content.each do |row|
      current_grid << row.split('').map { |e| e == '*' ? 1 : 0 }
    end
  end

  def create_generation
    @generation = Generation.create(
      world: Time.now.to_i.to_s,
      iteration: current_iteration,
      grid: current_grid
    )
  end
end
