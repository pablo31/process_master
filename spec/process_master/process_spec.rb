require 'spec_helper'

module ProcessMaster
  RSpec.describe Process do

    it 'should iterate with initial & target value' do
      acum = 0
      step = proc do |process, countdown|
        acum += 1
        countdown -= 1
      end
      process = Process.new(step, nil, 0, 5)
      process.start!
      expect(acum).to eq 5
    end

    it 'should iterate without initial value' do
      acum = 0
      step = proc do |process, countdown|
        countdown ||= 5
        acum += 1
        countdown -= 1
      end
      process = Process.new(step, nil, 0)
      process.start!
      expect(acum).to eq 5
    end

    it 'should iterate using a custom progress control' do
      progress_control = double 'progress_control'
      expect(progress_control).to receive(:fetch_state).with(no_args).once.and_return 1
      expect(progress_control).to receive(:put_state).with(0).once
      acum = 0
      step = proc do |process, countdown|
        acum += 1
        countdown -= 1
      end
      process = Process.new(step, progress_control, 0)
      process.start!
      expect(acum).to eq 1
    end

  end
end
