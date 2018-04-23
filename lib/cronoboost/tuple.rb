module Cronoboost
  ##
  #
  #
  class Tuple
    attr_reader :month
    attr_reader :day
    attr_reader :hour
    attr_reader :minute

    def initialize(month:, day:, hour:, minute:)
      @month  = month
      @day    = day
      @hour   = hour
      @minute = minute
    end
  end
end
