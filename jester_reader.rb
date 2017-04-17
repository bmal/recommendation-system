require 'httparty'
require 'zip'
require 'roo'
require 'roo-xls'

class JesterReader
    LINK = 'http://www.ieor.berkeley.edu/~goldberg/jester-data/jester-data-1.zip'
    TMP_XLS_FILE = 'jester_tmp.xls'
    DATA_FILE = /jester-data-\d\.xls/
    NOT_RATED = 99

    public
    def initialize
        @input = HTTParty.get(LINK).body
    end

    def get_prefs
        prefs = {}
        Zip::InputStream.open(StringIO.new(@input)) do |zip_file|
            while entry = zip_file.get_next_entry
                if DATA_FILE === entry.name 
                    data_file = entry.get_input_stream.read
                    File.open(TMP_XLS_FILE, 'w') do |file|
                        file.print(data_file)
                    end

                    data_file = Roo::Excel.new("jester.xls")
                    data_sheet = data_file.sheet(data_file.sheets.first)
                    data_file.each.with_index do |row, user_id|
                        prefs[user_id] = get_user_data(row)
                    end

                    File.delete(TMP_XLS_FILE)
                end
            end
        end

        prefs
    end

    private
    def get_user_data(row)
        rated_objects_and_ratings = {}
        row.each.with_index do |rating, object_id|
            if rating != NOT_RATED && object_id != 0
                rated_objects_and_ratings[object_id] = normalize_rating(rating)
            end
        end

        rated_objects_and_ratings
    end

    def normalize_rating(rating)
        1 + (10 + rating) / 5
    end
end
