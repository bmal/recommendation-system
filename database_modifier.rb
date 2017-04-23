require_relative 'movie_lens_1m_reader'
require 'set'

class DataSetModifier
    def initialize(prefs)
        @prefs = prefs
        puts "starting stats:"
        print_stats(@prefs)
    end

    def get_small_data_set
        data_set_after_users_decimation = @prefs.to_a.sample(get_number_of_users(@prefs)/10, random: Random.new(8))
        objects_to_keep = get_all_objects(@prefs).sample(get_number_of_objects(@prefs)/10, random: Random.new(8))

        small_data_set = keep_only_selected_objects(data_set_after_users_decimation, objects_to_keep)

        puts "small data set:"
        print_stats(small_data_set)
        
        small_data_set
    end

    def get_big_data_set
        data_set_after_users_decimation = @prefs.to_a.sample((get_number_of_users(@prefs)/Math.sqrt(10)).to_i, random: Random.new(13))
        objects_to_keep = get_all_objects(@prefs).sample((get_number_of_objects(@prefs)/Math.sqrt(10)).to_i, random: Random.new(13))

        big_data_set = {}
        data_set_after_users_decimation.each do |user, rated_objects|
            big_data_set[user] = rated_objects.select do |object_name, _|
                objects_to_keep.include? object_name
            end.to_h
        end

        big_data_set = keep_only_selected_objects(data_set_after_users_decimation, objects_to_keep)

        puts "big data set:"
        print_stats(big_data_set)

        big_data_set
    end

    def get_data_set_with_low_density
        sorted_objects_and_its_number_of_ratings = get_all_objects_sorted_by_rate_frequency(@prefs).to_a.reverse.to_h
        objects_to_keep = get_objects_having_10_percent_of_ratings(sorted_objects_and_its_number_of_ratings)

        rare_data_set = keep_only_selected_objects(@prefs, objects_to_keep)

        puts "rare data set:"
        print_stats(rare_data_set)

        rare_data_set
    end

    def get_data_set_with_high_density
        sorted_objects_and_its_number_of_ratings = get_all_objects_sorted_by_rate_frequency(@prefs)
        objects_to_keep = get_objects_having_10_percent_of_ratings(sorted_objects_and_its_number_of_ratings)

        dense_data_set = keep_only_selected_objects(@prefs, objects_to_keep)

        puts "dense data set:"
        print_stats(dense_data_set)

        dense_data_set
    end

    private
    def print_stats(data_set)
        puts "liczba ocen: #{get_number_of_ratings(data_set)}"
        puts "liczba ocenianych obiektów: #{get_number_of_objects(data_set)}"
        puts "liczba użytkowników: #{get_number_of_users(data_set)}"
        puts "gęstość: #{get_density(data_set)}%"
    end

    def get_number_of_ratings(data_set)
        data_set.inject(0) do |sum, (_, rated_objects)|
            sum + rated_objects.size
        end
    end

    def get_number_of_objects(data_set)
        set = Set.new

        data_set.each do |(_, rated_objects)|
            rated_objects.each do |(object_name, _)|
                set.add(object_name)
            end
        end

        set.size
    end

    def get_number_of_users(data_set)
        data_set.size
    end

    def get_density(data_set)
        ((get_number_of_ratings(data_set) / get_number_of_users(data_set).to_f) / get_number_of_objects(data_set).to_f)*100
    end

    def get_all_objects(data_set)
        set = Set.new

        data_set.each do |(_, rated_objects)|
            rated_objects.each do |(object_name, _)|
                set.add(object_name)
            end
        end

        set.to_a
    end

    def get_all_objects_sorted_by_rate_frequency(data_set)
        objects_and_number_of_ratings = {}
        objects_and_number_of_ratings.default = 0

        data_set.each do |(_, rated_objects)|
            rated_objects.each do |(object_name, _)|
                objects_and_number_of_ratings[object_name] += 1
            end
        end

        objects_and_number_of_ratings.to_a.sort_by { |(_, v)| v }.reverse.to_h
    end

    def get_objects_having_10_percent_of_ratings(sorted_objects_and_its_number_of_ratings)
        number_of_ratings = get_number_of_ratings(@prefs)
        current_number_of_ratings = 0
        selected_objects = []

        sorted_objects_and_its_number_of_ratings.each do |(object_name, number_of_object_ratings)|
            if(current_number_of_ratings < 0.1*number_of_ratings)
                current_number_of_ratings += number_of_object_ratings
                selected_objects << object_name
            end
        end

        selected_objects
    end

    def remove_users_with_no_objects_rated(data_set)
        data_set.reject { |user, ratings| ratings.empty? }
    end

    def keep_only_selected_objects(data_set, objects_to_keep)
        resultative_data_set = {}
        data_set.each do |user, rated_objects|
            resultative_data_set[user] = rated_objects.select do |object_name, _|
                objects_to_keep.include? object_name
            end.to_h
        end

        data_set = remove_users_with_no_objects_rated(resultative_data_set)
    end
end

modifier = DataSetModifier.new(MovieLens1mReader.new.get_prefs)
modifier.get_small_data_set
modifier.get_big_data_set
modifier.get_data_set_with_high_density
modifier.get_data_set_with_low_density
