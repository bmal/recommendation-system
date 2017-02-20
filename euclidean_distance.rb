require_relative 'correlation_coefficient'

class EuclideanDistance < CorrelationCoefficient
    def calculate_similarity(person1, person2)
        objects_rated_by_both_persons = try_to_aquire_mutualy_rated_objects(person1, person2)
        calculate_euclidean_distance(person1, person2, objects_rated_by_both_persons)
    rescue NoMutualyRatedObjects
        return 0
    end

    private
    def calculate_euclidean_distance(person1, person2, objects_rated_by_both_persons)
        distance = Math.sqrt(objects_rated_by_both_persons.inject(0) do |sum, rated_object|
            sum + (@prefs[person1][rated_object] - @prefs[person2][rated_object])**2
        end)

        normalize_euclidean_distance(distance)
    end

    def normalize_euclidean_distance(distance)
        1/(1 + distance)
    end
end
