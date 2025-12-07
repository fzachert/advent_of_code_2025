
require 'matrix'

def char_to_digit(c)
    if c == "."
        return 0
    else
        return 1
    end
end

def count_blocked_neighbors(data, row, col)
    count = 0
    for d_row in -1..1
        for d_col in -1..1
            if d_row == 0 and d_col == 0
                next
            end
            neighbor_row = row + d_row
            neighbor_col = col + d_col
            if neighbor_row >= 0 and neighbor_row < data.row_count and neighbor_col >= 0 and neighbor_col < data.column_count
                if data[neighbor_row, neighbor_col] == 1
                    count += 1

                end
            end
        end
    end
    return count
end

def count_accessible_positions(data)
    count = 0
    data.each_with_index do |value, row, col|
        if value == 1
            blocked_neighbors = count_blocked_neighbors(data, row, col)
            if blocked_neighbors < 4
                count += 1
            end
        end
    end
    return count
end

def main
    rows = []
    File.foreach('input.txt') do |line|
        #puts line
        # Add line as row to data structure
        rows << line.chomp.chars.map { |c| char_to_digit(c) }
    end
    data = Matrix.rows(rows)
    #puts data.inspect
    
    accessible_count = count_accessible_positions(data)
    puts "Number of accessible positions with >=4 blocked neighbors: #{accessible_count}"
end

main()