require 'cronoboost'

RSpec.describe Cronoboost::Task do
  context 'calculation when the task runs next' do
    context 'given a Tuple' do
      it 'runs in the next minute, if all attributes are *' do
        tuple = Cronoboost::Tuple.new # when not giving an attribute, the default is *
        task = Cronoboost::Task.new nil, tuple
        time = Time.now + 60

        next_run = task.next_run_at

        expect(next_run.to_s).to eql(Time.new(time.year, time.month, time.day, time.hour, time.min).to_s)
      end

      # hourly
      it 'runs at the first minute of the next hour if the attributes are minute = 0' do
        tuple = Cronoboost::Tuple.new minute: 0
        task = Cronoboost::Task.new nil, tuple
        time = Time.now + 3_600

        next_run = task.next_run_at

        expect(next_run.to_s).to eql(Time.new(time.year, time.month, time.day, time.hour).to_s)
      end

      # daily
      it 'runs tomorrow at midnight if the attributes are minute = 0 and hour = 0' do
        tuple = Cronoboost::Tuple.new hour: 0, minute: 0
        task = Cronoboost::Task.new nil, tuple
        time = Time.now + 86_400

        next_run = task.next_run_at

        expect(next_run.to_s).to eql(Time.new(time.year, time.month, time.day).to_s)
      end

      it 'runs at the start of the week if the attributes are day = */7, minute = 0 and hour = 0' do
      end

      # monthly
      it 'runs at the start of the month at midnight if the attributes are day = 1, minute = 0 and hour = 0' do
        tuple = Cronoboost::Tuple.new day: 1, hour: 0, minute: 0
        task = Cronoboost::Task.new nil, tuple
        time = Time.now

        next_run = task.next_run_at

        if time.month < 12
          expect(next_run.to_s).to eql(Time.new(time.year, time.month + 1).to_s)
        else
          expect(next_run.to_s).to eql(Time.new(time.year + 1, 1).to_s)
        end
      end
    end

    context 'given an Integer' do
      it 'runs now, if not run before' do
        task = Cronoboost::Task.new nil, 60

        next_run = task.next_run_at

        expect(next_run.to_s).to eql(Time.now.to_s)
      end

      it 'runs 60 seconds from now, if already run now' do
        task = Cronoboost::Task.new -> {}, 60
        task.run

        next_run = task.next_run_at

        expect(next_run.to_s).to eql((Time.now + 60).to_s)
      end
    end

    context 'given a Time' do
      it 'runs at the given time today, if it is ahead of the current time' do
        time = Time.now + 3_600
        task = Cronoboost::Task.new nil, time

        next_run = task.next_run_at

        expect(next_run.to_s).to eql(time.to_s)
      end

      it 'runs at the given time tomorrow, if it is behind the current time' do
        time = Time.now - 3_600
        task = Cronoboost::Task.new nil, time

        next_run = task.next_run_at

        expect(next_run.to_s).to eql((time + 86_400).to_s)
      end

      it 'runs at the given time and after running it will run tomorrow at the same time' do
        time = Time.now + 3_600
        task = Cronoboost::Task.new -> {}, time
        task.run

        next_run = task.next_run_at

        expect(next_run.to_s).to eql((time + 86_400).to_s)
      end

      it 'runs at the given time and date, if it is not a repeating task' do
        time = Time.now + 3_600
        task = Cronoboost::Task.new nil, time, false

        next_run = task.next_run_at

        expect(next_run.to_s).to eql(time.to_s)
      end

      it 'does not have a next_run at, if it is not a repeating task, even if it is in the past' do
        time = Time.now - 3_600
        task = Cronoboost::Task.new nil, time, false

        next_run = task.next_run_at

        expect(next_run).to eql(nil)
      end

      it 'does not have a next_run_at when it is not a repeating task and it was already executing' do
        time = Time.now + 3_600
        task = Cronoboost::Task.new -> {}, time, false
        task.run

        next_run = task.next_run_at

        expect(next_run).to eql(nil)
      end
    end
  end
end
