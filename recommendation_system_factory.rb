require_relative 'content_based_filtering'
require_relative 'collaborative_filtering'
require_relative 'percent_printer'

class RecommendationSystemFactory
    def initialize(prefs, correlation_coefficient_calculator, similarity_threshold = 0, percent_printer = PercentPrinter.new)
        @prefs = prefs
        @correlation_coefficient_calculator = correlation_coefficient_calculator
        @similarity_threshold = similarity_threshold
        @percent_printer = percent_printer
    end

    def createContentBasedFilteringSystem
        ContentBasedFiltering.new(@prefs, @correlation_coefficient_calculator, @percent_printer, @similarity_threshold)
    end

    def createCollaborativeFilteringSystem
        CollaborativeFiltering.new(@prefs, @correlation_coefficient_calculator, @similarity_threshold)
    end
end
