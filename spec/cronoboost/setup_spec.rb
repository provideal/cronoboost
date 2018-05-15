require 'cronoboost'

RSpec.describe Cronoboost::Setup do
  context 'load_tasks of Cronofile' do
    it 'returns empty list of tasks, if no executable task is in file' do
      tasks = nil
      File.open('/dev/null', 'r') do |f|
        tasks = Cronoboost::Setup.load_tasks(f)
      end

      expect(tasks.class).to be(Array)
      expect(tasks.count).to be(0)
    end

    it 'returns a list with 3 tasks, if 3 tasks are in the file' do
      tasks = nil
      File.open(File.expand_path('../mock/Cronofile', __dir__), 'r') do |f|
        tasks = Cronoboost::Setup.load_tasks(f)
      end

      expect(tasks.class).to be(Array)
      expect(tasks.count).to be(3)
    end
  end
end
