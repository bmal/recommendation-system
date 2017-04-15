require_relative 'movie_lens_100k_reader'
require_relative 'experimenter'

class CsvPrinter
    def print_report(filename, report)
        File.open(filename, 'w') do |file|
            print_header(file)
            report.each do |(removal_factor, removal_factor_report)|
                removal_factor_report.each do |(recommendation_system_name, recommendation_system_report)|
                    recommendation_system_report.get_time_standard_deviations[:recommendation_generation_time].each do |(n, _)|
                        file.print "#{recommendation_system_name},"
                        file.print "#{removal_factor},"
                        file.print "#{recommendation_system_report.get_average_times[:system_generation_time]},"
                        file.print "#{recommendation_system_report.get_time_standard_deviations[:system_generation_time]},"
                        file.print "#{n},"
                        file.print "#{recommendation_system_report.get_average_times[:recommendation_generation_time][n]},"
                        file.print "#{recommendation_system_report.get_time_standard_deviations[:recommendation_generation_time][n]},"
                        file.puts "#{recommendation_system_report.get_mean_square_error[n]}"
                    end
                end
            end
        end
    end

    private
    def print_header(file)
            file.print "System rekomendacyjny,"
            file.print "Procent usuniętych elementów,"
            file.print "Średni czas generowania systemu,"
            file.print "Odchylenie standardowe czasu generowania systemu,"
            file.print "n-sąsiadów,"
            file.print "Średni czas generowania rekomendacji,"
            file.print "Odchylenie standardowe czasu generowania rekomendacji,"
            file.puts "Błąd średniokwadratowy"
    end
end

e = Experimenter.new
report = e.perform_tests_and_generate_report(number_of_folds: 10) { TestHelper::CRITICS }

printer = CsvPrinter.new
printer.print_report("test.csv", report)
