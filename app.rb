# frozen_string_literal: true

require 'json'

require './lib/task'

file = File.read('./tasks.json')
data_hash = JSON.parse(file, symbolize_names: true)

taks_to_run = []

data_hash[:tasks].each do |j_task|
  task = Task.new(j_task)

  taks_to_run << task if task.to_run_now?
end

if taks_to_run.size.zero?
  puts '0 tasks found!'

  return
end

taks_to_run.each(&:run)
