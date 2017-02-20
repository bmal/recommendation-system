class NoMutualyRatedObjects < StandardError
end

class CorrelationCoefficient
    public
    attr_writer :prefs
    def initialize(prefs)
        @prefs = prefs.to_h
    end

    def tanimoto_distance(person1, person2)
        objects_rated_by_both_persons = get_mutualy_rated_objects(person1, person2)

        if objects_rated_by_both_persons.empty?
            return 0
        end

#        objects_rated_by_both_persons.size / get_total_number_of_movies_seen_by(person1, person2)
        number_of_identical_scores = objects_rated_by_both_persons.inject(0) do |sum, rated_object|
            sum + (@prefs[person1][rated_object] == @prefs[person2][rated_object] ? 1 : 0)
        end

        number_of_identical_scores / objects_rated_by_both_persons.size.to_f
    end

    private
    def try_to_aquire_mutualy_rated_objects(person1, person2)
        if isPersonInDataset(person1) && isPersonInDataset(person2)
            objects_rated_by_both_persons = create_collection_of_objects_rated_by_both_persons(person1, person2)
            unless objects_rated_by_both_persons.empty?
                return objects_rated_by_both_persons
            end
        end

        raise NoMutualyRatedObjects
    end

    def get_mutualy_rated_objects(person1, person2)
        if isPersonInDataset(person1) && isPersonInDataset(person2)
            create_collection_of_objects_rated_by_both_persons(person1, person2)
        else
            []
        end
    end

    def isPersonInDataset(person)
        @prefs.keys.include?(person)
    end

    def create_collection_of_objects_rated_by_both_persons(person1, person2)
        @prefs[person1].keys.select { |rated_object| @prefs[person2].has_key? rated_object }
    end

    def get_total_number_of_movies_seen_by(person1, person2)
        (@prefs[person1].keys | @prefs[person2].keys).size
    end
end
