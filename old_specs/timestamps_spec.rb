require "spec_helper"
require "timestamps"

describe Timestamps do
  context "invalid inputs" do
    it "returns 0 with invalid imputs" do
      ts = Timestamps.new([0, 10, 20, 30])
      [-1, :a, "hola", Object.new].each do |input|
        ts.time_at(input).should == 0
      end
    end
  end

  context "empty collection" do
    it "returns 0 at 0" do
      ts = Timestamps.new([])
      ts.time_at(0).should == 0
    end

    it "returns 0 at > 0" do
      ts = Timestamps.new([])
      ts.time_at(10).should == 0
    end
  end

  context "with timestamps and valid imputs" do
    let(:subject) { Timestamps.new([0, 10, 20]) }

    it "returns the exact time" do
      subject.time_at(0).should == 0
      subject.time_at(10).should == 10
      subject.time_at(20).should == 20
    end

    it "returns the previous valid time if no exact time in the collection" do
      subject.time_at(5).should == 0
      subject.time_at(15).should == 10
    end

    it "returns the last time when passing a time greater than the greater time" do
      subject.time_at(25).should == 20
    end
  end
end
