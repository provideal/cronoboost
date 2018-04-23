module Cronoboost
  ##
  #
  #
  class Worker
    ##
    #
    #
    def self.run(tasks)
      (defined?(logger) ? logger : Logger.new(STDOUT)).info("Running the worker with #{tasks.count} tasks")

      now = Time.now

      tasks.each do |task|
        next if task.next_run_at > now
        task.run
      end
    end
  end
end
