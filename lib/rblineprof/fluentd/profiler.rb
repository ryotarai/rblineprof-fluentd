require 'rblineprof/fluentd'
require 'fluent-logger'
require 'rblineprof'

module Rblineprof
  module Fluentd
    class Profiler
      def initialize(options)
        tag = options[:tag]
        @logger = Fluent::Logger::FluentLogger.new(tag, host: options[:host], port: options[:port])
      end

      def profile(options, &block)
        options = {pattern: /./, tag: 'rblineprof'}.merge(options)

        profiles = Hash[lineprof(options[:pattern], &block).map do |file, profile|
          total = profile.shift
          profile = profile.each_with_index.map do |record, line|
            record.unshift(line + 1)
          end.reject do |record|
            record[1..-1] == [0, 0, 0, 0]
          end.compact.unshift(total)

          [file, profile]
        end]

        @logger.post(options[:tag], {'profiles' => profiles})
      end
    end
  end
end

