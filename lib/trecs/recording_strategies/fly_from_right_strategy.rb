require "recording_strategies/strategy"

module TRecs
  class FlyFromRightStrategy
    include Strategy

    attr_reader :message
    attr_reader :width
    attr_reader :command

    def initialize(options={})
      @message = options.fetch(:message)
      @width = options.fetch(:width) { 10 }

      @width = @message.size if @width < @message.size

      @command = options.fetch(:command) { nil }
    end

    def perform
      time = 0
      message.each_char.inject("") do |current_msg, current_char|
        current_time(time)
        current_content(current_msg)
        save_frame
        ((width-1)-current_msg.size).downto(1) do |i|
          time    += recorder.step
          content = current_msg + " " * i + current_char

          current_time(time)
          current_content(content)
          save_frame
        end

        current_msg += current_char

        time    += recorder.step
        content = current_msg

        current_time(time)
        current_content(content)
        save_frame

        time    += recorder.step
        content = current_msg

        current_msg
      end
    end

    def current_content(str)
      if command
        comm_array = command.split(" ")
        str = IO.popen([*comm_array, "#{str}"]).read
      end
      super(str)
    end

  end
end
