# frozen_string_literal: true

class GenerationDecorator < Draper::Decorator
  delegate_all

  def complete_output
    generation_text = "Generation #{object.iteration}:"
    size_text = [object.grid.count, object.grid[0].count].join(' ')
    grid_text = serialize_grid(grid: object.grid)
    [generation_text, size_text, grid_text].join("\n")
  end

  def title
    "Generation #{object.iteration}:"
  end

  def size
    [object.grid.count, object.grid[0].count].join(' ')
  end

  def grid_text
    serialize_grid(grid: object.grid)
  end

  private

  def serialize_grid(grid:)
    grid.map { |a| a.join('') }.join("\n").gsub('0', '.').gsub('1', '*')
  end
end
