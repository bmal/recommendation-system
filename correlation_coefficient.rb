class CorrelationCoefficient
    public
    attr_writer :prefs
    def initialize(prefs)
        @prefs = prefs.to_h
    end

    def euclidean_distance(person1, person2)
        rated = get_mutualy_rated(person1, person2)

        if rated.empty?
            return 0
        end

        distance = Math.sqrt(rated.inject(0) { |sum, k| sum + (@prefs[person1][k] - @prefs[person2][k])**2 })
        1/(1 + distance)
    end

    def pearson_distance(person1, person2)
        rated = get_mutualy_rated(person1, person2)

        if rated.empty?
            return 0
        end

        person1_average_rating = get_average_rating(person1, rated)
        person2_average_rating = get_average_rating(person2, rated)

        covariance = rated.inject(0) do |sum, k|
            sum + (@prefs[person1][k] - person1_average_rating)*(@prefs[person2][k] - person2_average_rating)
        end

        person1_standard_deviation = get_standard_deviation(person1, person1_average_rating, rated)
        person2_standard_deviation = get_standard_deviation(person2, person2_average_rating, rated)

        covariance / (person1_standard_deviation*person2_standard_deviation)
    end

    def tanimoto_distance(person1, person2)
        rated = get_mutualy_rated(person1, person2)

        if rated.empty?
            return 0
        end

#        rated.size / get_total_number_of_movies_seen_by(person1, person2)
        number_of_identical_scores = rated.inject(0) do |sum, k|
            sum + (@prefs[person1][k] == @prefs[person2][k] ? 1 : 0)
        end

        number_of_identical_scores / rated.size.to_f
    end

    private
    def get_mutualy_rated(person1, person2)
        if @prefs.keys.include?(person1) && @prefs.keys.include?(person2)
            @prefs[person1].keys.select { |k| @prefs[person2].has_key? k }
        else
            []
        end
    end

    def get_total_number_of_movies_seen_by(person1, person2)
        (@prefs[person1].keys | @prefs[person2].keys).size
    end

    def get_average_rating(person, rated)
        rated.inject(0) { |sum, k| sum + @prefs[person][k] } / rated.size
    end

    def get_standard_deviation(person, average_rating, rated)
        Math.sqrt(rated.inject(0) do |sum, k|
            sum + (@prefs[person][k] - average_rating) ** 2
        end)
    end
end
