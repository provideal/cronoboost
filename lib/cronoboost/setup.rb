module Cronoboost
  ##
  # The Setup class provides methods to initialize Cronoboost,
  # loading the tasks and can aggregate errors and statuses of these tasks.
  #
  class Setup
    attr_reader :tasks

    def initialize(tasks)
      @tasks = tasks
    end

    def errors
      @tasks.map(&:errors)
    end

    def status
      @tasks.map(&:status)
    end

    ##
    # Runs the setup and creates a new Cronoboost::Setup instance.
    #
    def self.run(path_to_init_file = nil)
      path_to_init_file ||= (defined?(Rails) ? Rails.root : '') + 'Cronofile'
      Cronoboost.logger.info "Loading initializer file from '#{path_to_init_file}'"
      raise "The init file #{path_to_init_file} doesn't exist" unless File.exist?(path_to_init_file)
      tasks = File.open(path_to_init_file, 'r') { |f| Cronoboost::Setup.load_tasks(f) }
      Cronoboost::Setup.new tasks
    end

    ##
    # Parses the content of the file and executes it.
    # Every line that creates a Cronoboost::Task, will be returned
    #
    def self.load_tasks(file)
      file.read.split("\n").map do |line|
        res = eval line, binding, __FILE__, __LINE__
        res if res.is_a? Cronoboost::Task
      end.compact
    end
  end
end
