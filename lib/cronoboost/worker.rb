module Cronoboost
  ##
  #
  #
  class Worker
    ##
    #
    #
    def self.run(instance)
      (defined?(logger) ? logger : Logger.new(STDOUT)).info "Running the worker with #{tasks.count} tasks"

      now = Time.now

      instance.tasks.each do |task|
        next if task.next_run_at > now
        task.run
      end
    end
  end
end
