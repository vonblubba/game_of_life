# frozen_string_literal: true

namespace :generation do
  desc 'calculates next generation from an input generation file'

  task :calculate_next, [:file_path] => :environment do |t, args|
    abort "cannot find file #{args[:file_path]}" unless File.exist?(args[:file_path])

    s = IteratorService.new(file_path: args[:file_path])
    next_gen = s.run[:next_gen]

    puts next_gen.decorate.complete_output
  end
end
