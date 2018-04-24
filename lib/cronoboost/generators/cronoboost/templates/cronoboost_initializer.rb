Cronoboost.configure do |config|
  # Choose between cronoboost and activejob.
  # `cronoboost` executes the tasks directly
  # while `activejob` creates a job, that will
  # run in the background.
  config.default_job_initializer = 'cronoboost'
end
