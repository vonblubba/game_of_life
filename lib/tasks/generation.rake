# frozen_string_literal: true

namespace :generation do
  desc 'calculates next generation from an input generation file'

  task :calculate_next, [:file_path] => :environment do |t, args|
    abort "cannot find file #{args[:file_path]}" unless File.exist?(args[:file_path])

    current_gen = GenerationCreationService.new(file_path: args[:file_path]).run
    next_gen = IteratorService.new(current_gen_id: current_gen.id).run[:next_gen]

    puts next_gen.decorate.complete_output
  end
end
