require_relative '../analyzer'
require 'minitest/autorun'
require 'minitest/ci'

class AnalyzerTestSuite < MiniTest::Test
    RESULTS = {}
    def setup
        @sut = Analyzer.new(RESULTS)
    end
end
