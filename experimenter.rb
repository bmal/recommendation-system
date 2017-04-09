require_relative 'recommendation_system_factory'
require_relative 'correlation_coefficient_factory'
require_relative 'movie_lens_100k_reader'
require_relative 'test/test_helper'
require_relative 'cross_validation'
require_relative 'benchmark'
require_relative 'analyzer'

prefs = TestHelper::CRITICS #MovieLens100kReader.new.get_prefs
similarity = CorrelationCoefficientFactory.new(prefs).createTanimotoSimilarity
b = Benchmark.new(CrossValidation.new(prefs, 2))

results = b.perform do |fold|
    RecommendationSystemFactory.new(fold, similarity).createContentBasedFilteringSystem
end

a = Analyzer.new(results)
p a.get_mean_square_error
