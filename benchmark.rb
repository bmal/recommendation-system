require_relative 'recommendation_system_factory'
require_relative 'correlation_coefficient_factory'
require_relative 'movie_lens_100k_reader'
require_relative 'test/test_helper'
require_relative 'cross_validation'

prefs = TestHelper::CRITICS #MovieLens100kReader.new.get_prefs
CrossValidation.new(prefs, 2).each {|chunk| puts "testowy: #{chunk[:testing_set]}\ntreningowy: #{chunk[:training_set]}" }
similarity = CorrelationCoefficientFactory.new(prefs).createTanimotoSimilarity
p RecommendationSystemFactory.new(prefs, similarity).createCollaborativeFilteringSystem.calculate_recommendations('Donald Trump')
