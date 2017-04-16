require_relative 'content_based_filtering'
require_relative 'collaborative_filtering'

class RecommendationSystemFactory
    def initialize(prefs, correlation_coefficient_calculator, similarity_threshold = 0)
        @prefs = prefs
        @correlation_coefficient_calculator = correlation_coefficient_calculator
        @similarity_threshold = similarity_threshold
    end

    def create_content_based_filtering_system
        ContentBasedFiltering.new(@prefs, @correlation_coefficient_calculator, @similarity_threshold)
    end

    def create_collaborative_filtering_system
        CollaborativeFiltering.new(@prefs, @correlation_coefficient_calculator, @similarity_threshold)
    end
end
