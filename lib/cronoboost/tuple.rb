module Cronoboost
  ##
  # The Tuple is a class, that contains the values for
  # month, day_of_week, day, hour and minute.
  # These are values similar to those in a normal crontab
  #
  class Tuple
    attr_reader :month
    attr_reader :day_of_week
    attr_reader :day
    attr_reader :hour
    attr_reader :minute

    def initialize(month: '*', day_of_week: '*', day: '*', hour: '*', minute: '*')
      @month = month
      @day_of_week = day_of_week
      @day = day
      @hour = hour
      @minute = minute
    end
  end
end
