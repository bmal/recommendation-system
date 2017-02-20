require_relative 'euclidean_distance'
require_relative 'pearson_correlation_coefficient'
require_relative 'tanimoto_similarity'

class CorrelationCoefficientFactory
    def initialize(prefs)
        @prefs = prefs
    end

    def createEuclideanDistance
        EuclideanDistance.new(@prefs)
    end

    def createPearsonCorrelationCoefficient
        PearsonCorrelationCoefficient.new(@prefs)
    end

    def createTanimotoSimilarity
        TanimotoSimilarity.new(@prefs)
    end
end
