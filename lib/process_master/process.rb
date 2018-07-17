module ProcessMaster
  class Process

    def initialize(step_proc, progress_control, target_value, initial_value = nil)
      @step_proc = step_proc
      @progress_control = progress_control
      @initial_value = initial_value
      @target_value = target_value
      # actual value
      @value = initial_value
    end

    def start!
      while @value != @target_value
        @value = @progress_control.fetch_state if @progress_control
        @value = step!
        @progress_control.put_state(@value) if @progress_control
      end
    end

    def step!
      @step_proc.call(self, @value)
    end

  end
end
