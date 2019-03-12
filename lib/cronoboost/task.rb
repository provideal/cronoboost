module Cronoboost
  ##
  # A Task calls the callback, when run is called.
  # It can calculate the time, when it will be next executed.
  #
  class Task
    attr_reader :last_run_at
    attr_reader :status
    attr_reader :errors

    def initialize(callback, run_schema, repeat = true)
      @callback = callback
      @run_schema = run_schema
      @repeat = repeat

      @last_run_at = nil
      @next_run_at = calculate_next_run_at
      @status = 'created'
      @errors = []
    end

    ##
    # Runs the callback, it can handle different styles of callbacks
    #
    def run
      begin
        case @callback
        when String, Symbol
          send @callback
        when Proc, Lambda
          @callback.call
        end
      rescue StandardError => e
        @errors << e.message
        Cronoboost.logger.error e.message
        Cronoboost.logger.debug e.backtrace
      end

      @last_run_at = @next_run_at
      @next_run_at = calculate_next_run_at
    end

    ##
    # Returns a precalculated time or calculate the time,
    # when it will be executed the next time.
    #
    def next_run_at
      @next_run_at || calculate_next_run_at
    end

    private

    ##
    # 
    #
    def calculate_next_run_at
      case @run_schema
      when Cronoboost::Tuple
        calculate_for_tuple
      when Integer
        @last_run_at.nil? ? Time.now : @last_run_at + @run_schema
      when Time
        # When repeated, it runs it every day at the same time
        # When not repeated, it runs the task only at the given date and time
        return if !@repeat && (!@last_run_at.nil? || Time.now > @run_schema)

        @repeat ? calculate_for_time : @run_schema
      else
        return nil unless @repeat

        raise 'Unknown schema to calculate when to run next'
      end
    end

    ##
    #
    #
    def calculate_for_tuple
      run_at = @last_run_at || Time.now
      if @run_schema.minute == '*'
        run_at += 60
      elsif @run_schema.hour == '*'
        run_at += 3_600
      elsif @run_schema.day == '*' && @run_schema.day_of_week == '*'
        run_at += 86_400
      elsif @run_schema.month == '*'
        days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        num_of_days = days_in_month[run_at.month % 12]
        num_of_days = 29 if run_at.month == 1 && Date.gregorian_leap?(run_at.year)
        run_at += num_of_days * 86_400
      end

      case @run_schema.month
      when Integer then month = @run_schema.month
      when String
        month = @run_schema.month == '*' ? run_at.month : 0 # TODO: calculate the correct month
      end

      case @run_schema.day_of_week
      when Integer then day_of_week = @run_schema.day_of_week
      when String then day_of_week = @run_schema.day_of_week == '*'

      end

      case @run_schema.day
      when Integer then day = @run_schema.day
      when String
        day = @run_schema.day == '*' ? run_at.day : 1 # TODO: calculate the correct day
      end

      case @run_schema.hour
      when Integer then hour = @run_schema.hour
      when String
        hour = @run_schema.hour == '*' ? run_at.hour : 0 # TODO: calculate the correct hour
      end

      case @run_schema.minute
      when Integer then minute = @run_schema.minute
      when String
        minute = @run_schema.minute == '*' ? run_at.min : 0 # TODO: calculate the correct minute
      end

      Time.new run_at.year, month, day, hour, minute
    end

    ##
    #
    #
    def calculate_for_time
      now = Time.now
      if !@last_run_at.nil? || now > @run_schema
        tomorrow = now + 86_400
        Time.new tomorrow.year, tomorrow.month, tomorrow.day, @run_schema.hour, @run_schema.min, @run_schema.sec
      else
        Time.new now.year, now.month, now.day, @run_schema.hour, @run_schema.min, @run_schema.sec
      end
    end
  end
end
