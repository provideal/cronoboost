module Cronoboost
  ##
  #
  #
  class Setup
    attr_reader :tasks

    def initialize(tasks)
      @tasks = tasks
    end

    ##
    #
    #
    def self.run(path_to_init_file = '')
      (defined?(logger) ? logger : Logger.new(STDOUT)).info "Loading initializer file from '#{path_to_init_file}'"
      tasks = []
      File.open(path_to_init_file, 'r') do |f|
        f.read.split("\n").each do |line|
          res = eval line, binding, __FILE__, __LINE__
          tasks << res if res.is_a? Cronoboost::Task
        end
      end
      Cronoboost::Setup.new tasks
    end
  end
end
