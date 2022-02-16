# frozen_string_literal: true

require 'date'
require './lib/notify-send'

# instance of task
class Task
  attr_accessor :name, :slug, :date, :hour, :commands

  def initialize(task_params)
    task_params.each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end

    @now = DateTime.now
  end

  def to_run_now?
    date == @now.strftime('%Y-%m-%d') && hour == @now.strftime('%H:%M')
  end

  def run
    execute
    notify
  end

  private

  def notify
    NotifySend.send summary: "Task #{name} complete!", icon: 'info'
  end

  def log_file
    @log_file || "#{Dir.pwd}/logs/#{slug.strip}.log"
  end

  def write_log(data, append: false)
    append ? File.write(log_file, data, mode: 'a') : File.write(log_file, data)
  end

  def execute
    commands.each do |cmd|
      write_log ">>>> Running: #{cmd}\n\r"

      log_data = `#{cmd}`

      write_log(log_data)
    end
  end
end
