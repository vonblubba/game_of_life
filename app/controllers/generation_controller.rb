# frozen_string_literal: true

class GenerationController < ApplicationController
  before_action :generate_next_gen, only: [:show]

  def show
    @next_generation = @current_generation.next_generation.decorate
  end

  def perform_upload
    uploaded_io = params[:file_field]
    file_path = Rails.root.join('public', 'uploads', uploaded_io.original_filename)

    File.open(file_path, 'w') do |file|
      file.write(uploaded_io.read)
    end

    s = IteratorService.new(file_path: file_path)
    current_gen = s.run[:current_gen]

    redirect_to action: 'show', id: current_gen.id
  end

  private

  def generate_next_gen
    @current_generation = Generation.find(params[:id]).decorate
    return if @current_generation.next_generation.present?

    s = IteratorService.new(current_gen_id: @current_generation.id)
    s.run
  end
end
