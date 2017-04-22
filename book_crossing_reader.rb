require 'httparty'
require 'zip'

# liczba ocen: 433671
# liczba ocenianych obiektów: 185973
# liczba użytkowników: 77805
# gęstość: 0.00299711203%

class BookCrossingReader
    LINK = 'http://www2.informatik.uni-freiburg.de/~cziegler/BX/BX-CSV-Dump.zip'
    ITEM_NAMES_FILE = 'BX-Books.csv'
    DATA_FILE = 'BX-Book-Ratings.csv'

    public
    def initialize
        @input = HTTParty.get(LINK).body
    end

    def get_prefs
        book_ids_to_names = get_book_ids_to_names
        generate_prefs(book_ids_to_names)
    end

    private
    def get_book_ids_to_names
        mappings = {}

        Zip::InputStream.open(StringIO.new(@input)) do |zip_file|
            while entry = zip_file.get_next_entry
                if entry.name == ITEM_NAMES_FILE
                    entry.get_input_stream.read.each_line.with_index do |line, index|
                        line.scrub!
                        if index != 0
                            id, name = /\"(.+?)\";\"(.+?)\";/.match(line).captures
                            mappings[id] = name.strip
                        end
                    end
                end
            end
        end

        mappings
    end

    def generate_prefs(book_ids_to_names)
        prefs = {}

        Zip::InputStream.open(StringIO.new(@input)) do |zip_file|
            while entry = zip_file.get_next_entry
                if entry.name == DATA_FILE
                    entry.get_input_stream.read.each_line.with_index do |line, index|
                        if index != 0
                            user, book_id, rating = /\"(\d+)\";\"(.+?)\";\"(\d+)/.match(line).captures
                            if rating.to_i != 0
                                prefs[user] ||= {}
                                prefs[user][book_ids_to_names[book_id]] = normalize_rating(rating.to_i)
                            end
                        end
                    end
                end
            end
        end

        prefs
    end

    def normalize_rating(rating)
        1+(rating - 1)/(9/4)
    end
end
