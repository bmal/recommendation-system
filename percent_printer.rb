class PercentPrinter
    def set_size(size)
        @size = size
        @current_percent = -1
    end

    def restart
        @current_percent = -1
    end

    def print_percent(index)
        if @size != 0 && index != 0 && index.to_f/@size*100 > @current_percent
            @current_percent += 1
            puts "#{@current_percent}%"
        end
    end
end
