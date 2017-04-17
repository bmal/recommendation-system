require 'httparty'
require 'zip'

# liczba ocen: 10000209
# liczba ocenianych obiektów: 3883
# liczba użytkowników: 6040
# gęstość: 4.26%

class MovieLens1mReader
    LINK = 'http://files.grouplens.org/datasets/movielens/ml-1m.zip'
    ITEM_NAMES_FILE = 'ml-1m/movies.dat'
    DATA_FILE = 'ml-1m/ratings.dat'

    public
    def initialize
        @input = HTTParty.get(LINK).body
    end

    def get_prefs
        movie_ids_to_names = get_movie_ids_to_names
        generate_prefs(movie_ids_to_names)
    end

    private
    def get_movie_ids_to_names
        mappings = {}

        Zip::InputStream.open(StringIO.new(@input)) do |zip_file|
            while entry = zip_file.get_next_entry
                if entry.name == ITEM_NAMES_FILE
                    entry.get_input_stream.read.each_line do |line|
                        line.scrub!
                        id, name = /(\d+)::(\S+?[\w\s]+)/.match(line).captures
                        mappings[id] = name.strip
                    end
                end
            end
        end

        mappings
    end

    def generate_prefs(movie_ids_to_names)
        prefs = {}

        Zip::InputStream.open(StringIO.new(@input)) do |zip_file|
            while entry = zip_file.get_next_entry
                if entry.name == DATA_FILE
                    entry.get_input_stream.read.each_line do |line|
                        user, movie_id, rating = /(\d+)::(\d+)::(\w+)/.match(line).captures
                        prefs[user] ||= {}
                        prefs[user][movie_ids_to_names[movie_id]] = rating.to_i
                    end
                end
            end
        end

        prefs
    end
end
