module Measurement
  class MeasuredSubject
    attr_reader :subject, :measurements

    def initialize(subject, measurements)
      @subject = subject
      @measurements = measurements
    end

    def descriptions
      ["Subject"] + measurements.keys
    end

    def values
      [subject] + measurements.values
    end
  end
end
