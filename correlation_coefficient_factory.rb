require_relative 'euclidean_distance'
require_relative 'pearson_correlation_coefficient'
require_relative 'tanimoto_similarity'

class CorrelationCoefficientFactory
    def initialize(prefs)
        @prefs = prefs
    end

    def create_euclidean_distance
        EuclideanDistance.new(@prefs)
    end

    def create_pearson_correlation_coefficient
        PearsonCorrelationCoefficient.new(@prefs)
    end

    def create_tanimoto_similarity
        TanimotoSimilarity.new(@prefs)
    end
end
