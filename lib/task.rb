# frozen_string_literal: true

require 'pry'
require 'date'
require 'open3'

require './lib/notify_send'

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
    write_log('')

    execute
  end

  private

  def notify
    NotifySend.send summary: "Task #{name} complete!", icon: 'info'
  end

  def notify_error
    NotifySend.send summary: "Task #{name} error!", icon: 'error'
  end

  def log_file
    @log_file || "#{Dir.pwd}/logs/#{slug.strip}.log"
  end

  def write_log(data, append: false)
    return File.write(log_file, data, mode: 'a') if append && File.exist?(log_file)

    File.open(log_file, 'w') { |f| f.write(data) }
  end

  def execute
    commands.each do |cmd|
      header_log = ">>>> Running: #{cmd}\n\r"

      stdout, _stderr, status = Open3.capture3(cmd)

      write_log("#{header_log}#{stdout}\n\r#{status}")
    rescue StandardError => e
      write_log("#{header_log}\n\r#{e}", append: true)

      notify_error
      raise
    end

    notify
  end
end
