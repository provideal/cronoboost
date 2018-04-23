require 'cronoboost/version'
require 'cronoboost/setup'
require 'cronoboost/task'
require 'cronoboost/tuple'
require 'cronoboost/worker'

require 'logger'

##
# The Cronoboost module defines methods to queue tasks.
# Every method takes a callback function that will be executed.
# Some of the methods also take some attributes to configure,
# when they should run.
#
module Cronoboost
  ##
  # Alias for cronly
  #
  def self.custom(*args)
    cronly args
  end

  ##
  # Runs a task every time the attributes match.
  # Specify the time for the task like in cron.
  # If the attribute isn't given, it used * as default.
  # You can give an integer for every attribute, or
  # an equation like '*/5' for every fifth day.
  #
  def self.cronly(callback, month: '*', day: '*', hour: '*', minute: '*')
    tuple = Cronoboost::Tuple.new month: month, day: day, hour: hour, minute: minute
    Cronoboost::Task.new callback, tuple
  end

  ##
  # Runs a task every hour at the first minute.
  #
  def self.hourly(callback)
    cronly callback, minute: 0
  end

  ##
  # Runs a task every day at midnight.
  #
  def self.daily(callback)
    cronly callback, hour: 0, minute: 0
  end

  ##
  # Runs a task every beginning of the week.
  #
  def self.weekly(callback)
    cronly callback, day: '*/7', hour: 0, minute: 0
  end

  ##
  # Runs a task every first day of a month at midnight.
  #
  def self.monthly(callback)
    cronly callback, day: 1, hour: 0, minute: 0
  end

  ##
  # Runs a task every X seconds.
  # X is given by the interval attribute.
  #
  def self.every(callback, interval)
    unless interval.is_a? Integer
      raise 'The interval parameter for the every-method needs
             to be an integer representing the seconds between each run'\
    end
    Cronoboost::Task.new callback, interval
  end

  ##
  # Runs a task every day at a given time.
  # The time is given by the time attribute.
  #
  def self.at(callback, time)
    raise 'The time parameter for the at-method needs to be an object of type Time' unless time.is_a? Time
    Cronoboost::Task.new callback, time
  end

  ##
  # Runs a task exactly once at the given time.
  # The time is given by the time attribute. Ruby's Time can include a date.
  #
  def self.once(callback, time)
    raise 'The time parameter for the once-method needs to be an object of type Time' unless time.is_a Time
    Cronoboost::Task.new callback, datetime, false
  end

  ##
  # Runs a task when the cronoboost daemon is started.
  #
  def self.on_start(callback)
    Cronoboost::Task.new(callback, nil).run
  end
end
