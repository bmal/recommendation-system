require_relative 'recommendation_system_factory'
require_relative 'correlation_coefficient_factory'

prefs = MovieLens100kReader.new.get_prefs
similarity = CorrelationCoefficientFactory.new(prefs).createTanimotoSimilarity
p RecommendationSystemFactory.new(prefs, similarity).createContentBasedFilteringSystem.calculate_recommendations('5')
