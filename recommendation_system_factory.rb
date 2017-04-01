require_relative 'content_based_filtering'
require_relative 'collaborative_filtering'
require_relative 'percent_printer'

class RecommendationSystemFactory
    def initialize(prefs, similarity_threshold = 0, percent_printer = PercentPrinter.new)
        @prefs = prefs
        @similarity_threshold = similarity_threshold
        @percent_printer = percent_printer
    end

    def createContentBasedFilteringSystem
        ContentBasedFiltering.new(@prefs, @similarity_threshold, @percent_printer)
    end

    def createCollaborativeFilteringSystem
        CollaborativeFiltering.new(@prefs, @similarity_threshold)
    end
end
