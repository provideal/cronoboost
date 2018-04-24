class CronoboostTaskJob < ApplicationJob
  queue_as :default
 
  def perform(task)
    task.run
  end
end
