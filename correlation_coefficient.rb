class NoMutualyRatedObjects < StandardError
end

class CorrelationCoefficient
    public
    attr_writer :prefs
    def initialize(prefs)
        @prefs = prefs.to_h
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

    def isPersonInDataset(person)
        @prefs.keys.include?(person)
    end

    def create_collection_of_objects_rated_by_both_persons(person1, person2)
        @prefs[person1].keys.select { |rated_object| @prefs[person2].has_key? rated_object }
    end
end
