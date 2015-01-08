require 'spec_helper'

describe Rblineprof::Fluentd::Profiler do
  let(:logger) { double(:logger) }
  before do
    allow(Fluent::Logger::FluentLogger).to receive(:new).and_return(logger)
  end

  subject(:profiler) { described_class.new(host: 'localhost', port: 24224) }

  describe "#profile" do
    it "sends a profile via fluentd" do
      expect(logger).to receive(:post).with('rblineprof', kind_of(Hash))

      profiler.profile(pattern: /./) do
        sleep 0.1
      end
    end
  end
end

