require 'httparty'
require 'zip'

class MovieLens100kReader
    LINK = 'http://files.grouplens.org/datasets/movielens/ml-100k.zip'

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

        Zip::InputStream.open(StringIO.new(@input)) do |io|
            while entry = io.get_next_entry
                if entry.name == 'ml-100k/u.item'
                    entry.get_input_stream.read.each_line do |line|
                        line.scrub!
                        id, name = /(\d+)\|([\w,\s]+)/.match(line).captures
                        mappings[id] = name.strip
                    end
                end
            end
        end

        mappings
    end

    def generate_prefs(movie_ids_to_names)
        prefs = {}

        Zip::InputStream.open(StringIO.new(@input)) do |io|
            while entry = io.get_next_entry
                if entry.name == 'ml-100k/u.data'
                    entry.get_input_stream.read.each_line do |line|
                        user, movie_id, rating = /(\d+)\s+(\d+)\s+(\w+)/.match(line).captures
                        prefs[user] ||= {}
                        prefs[user][movie_ids_to_names[movie_id]] = rating.to_i
                    end
                end
            end
        end

        prefs
    end
end
