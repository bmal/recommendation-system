class PercentPrinter
    def set_size(size)
        @elems_per_one_percent = (size/100).to_i
        @current_percent = -1
    end

    def restart
        @current_percent = -1
    end

    def print_percent(index)
        if @elems_per_one_percent != 0 && index % @elems_per_one_percent == 0
            @current_percent += 1
            puts "#{@current_percent}%"
        end
    end
end

