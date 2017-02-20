require_relative 'correlation_coefficient'

class TanimotoSimilarity < CorrelationCoefficient
    private
    def calculate_distance(person1, person2, objects_rated_by_both_persons)
        number_of_identical_scores = calculate_number_of_identical_scores(person1, person2, objects_rated_by_both_persons)
        number_of_identical_scores / objects_rated_by_both_persons.size.to_f
    end

    def calculate_number_of_identical_scores(person1, person2, objects_rated_by_both_persons)
        objects_rated_by_both_persons.inject(0) do |sum, rated_object|
            sum + (@prefs[person1][rated_object] == @prefs[person2][rated_object] ? 1 : 0)
        end
    end
end
