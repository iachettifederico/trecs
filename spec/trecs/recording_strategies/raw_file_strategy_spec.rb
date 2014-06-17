require "spec_helper"
require "recording_strategies/raw_file_strategy"

module TRecs
  describe RawFileStrategy do
    context "initialization" do
      context "file" do
        Given(:input_file) { "tmp/input_file.txt" }
        Given { FileUtils.touch(input_file) }
        When(:strategy) { RawFileStrategy.new(file: input_file) }
        Then { Pathname(strategy.file).to_s == input_file }
      end

      context "file keyword" do
        When(:strategy) { RawFileStrategy.new }
        Then { expect(strategy).to have_failed(KeyError, /file/) }
      end

      context "file existence" do
        Given(:existent)   { "tmp/exist.txt" }
        Given(:inexistent) { "tmp/nope.txt" }
        Given { FileUtils.touch(existent) }
        Given { FileUtils.rm(inexistent, force: true) }

        When(:strategy1) { RawFileStrategy.new(file: existent) }
        Then { expect(strategy1).not_to have_failed }

        When(:strategy2) { RawFileStrategy.new(file: inexistent) }
        Then { expect(strategy2).to have_failed(Errno::ENOENT, /No such file or directory/) }
      end
    end

    context "recorder" do
      Given(:input_file)   { "tmp/input_file.txt" }
      Given { FileUtils.touch(input_file) }

      Given(:strategy) {
        RawFileStrategy.new(file: input_file)
      }
      Given(:recorder) { Object.new }
      When { strategy.recorder = recorder }
      Then { strategy.recorder == recorder }
    end

    # context "perform" do
    #   Given { Spy.clear }
    #   Given(:recorder) { Spy.new("recorder").ignore }

    #   Given(:input_file)   { "tmp/input_file.txt" }
    #   Given(:clock) { DummyClock.new }

    #   Given(:strategy) {
    #     RawFileStrategy.new(
    #       file: input_file,
    #       clock: clock)
    #   }

    #   When { recorder.stub(:step) { 100 } }
    #   When { strategy.recorder = recorder }

    #   When { strategy.perform }
    #   When {
    #     File.open(input_file, "rw") do |f|
    #       f.write "A"
    #       clock.sleep()
    #     end
    #   }

    #   When { strategy.stop }
    #   Then { recorder.calls[1]  == [:current_frame, [ {time: 0,    content: "A"}           ] ] }
    # end
  end
end
