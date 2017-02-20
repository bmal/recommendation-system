require_relative 'correlation_coefficient'

class PearsonCorrelationCoefficient < CorrelationCoefficient
    def calculate_similarity(person1, person2)
        objects_rated_by_both_persons = try_to_aquire_mutualy_rated_objects(person1, person2)
        calculate_pearson_correlation_coefficient(person1, person2, objects_rated_by_both_persons)
    rescue NoMutualyRatedObjects
        return 0
    end

    private
    def calculate_pearson_correlation_coefficient(person1, person2, objects_rated_by_both_persons)
        person1_average_rating = calculate_average_rating(person1, objects_rated_by_both_persons)
        person2_average_rating = calculate_average_rating(person2, objects_rated_by_both_persons)

        covariance = objects_rated_by_both_persons.inject(0) do |sum, rated_object|
            sum + (@prefs[person1][rated_object] - person1_average_rating)*(@prefs[person2][rated_object] - person2_average_rating)
        end

        person1_standard_deviation = calculate_standard_deviation(person1, person1_average_rating, objects_rated_by_both_persons)
        person2_standard_deviation = calculate_standard_deviation(person2, person2_average_rating, objects_rated_by_both_persons)

        covariance / (person1_standard_deviation*person2_standard_deviation)
    end

    def calculate_average_rating(person, objects_rated_by_both_persons)
        sum_of_scores = objects_rated_by_both_persons.inject(0) { |sum, rated_object| sum + @prefs[person][rated_object] }
        sum_of_scores / objects_rated_by_both_persons.size
    end

    def calculate_standard_deviation(person, average_rating, objects_rated_by_both_persons)
        Math.sqrt(objects_rated_by_both_persons.inject(0) do |sum, rated_object|
            sum + (@prefs[person][rated_object] - average_rating) ** 2
        end)
    end
end
