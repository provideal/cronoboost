module Cronoboost
  ##
  #
  #
  class Worker
    ##
    #
    #
    def self.run(instance)
      Cronoboost.logger.info "Running the worker with #{instance.tasks.count} tasks"

      now = Time.now

      instance.tasks.each do |task|
        next if task.next_run_at > now

        # if default_job_initializer == 'activejob'
        #   CronoboostTaskJob.new(task).perform_now
        # elsif default_job_initializer == 'cronoboost'
        task.run
        # end
      end
    end
  end
end
