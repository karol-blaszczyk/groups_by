module Pritifier
  require 'colorize'
  INDENT = "\t".freeze

  # @param arr [Array<Hash>] initialy source_arr
  # @param indent [Integer]
  def pritify(arr, indent = 0)
    indent += 1
    arr.each do |k, v|
      # indent = 0 unless i == 0
      if k == :values
        pritty_table(v, indent, 'green')
      elsif k == :totals
        pritty_table([v], indent, 'blue')
      else
        print "\n" + INDENT * indent + k.to_s.underline.red
        pritify(v, indent)
      end
    end
  end

  private

  def metrics_table_headers(keys, cell_size)
    keys.map { |key| key.to_s + ' ' * (cell_size - key.to_s.length) }
  end

  # Metrics table, or totals table, with values
  def pritty_table(array, indent, color = 'green')
    vmax = array.flat_map(&:values).map(&:to_s).map(&:length).max # find max value might be slow
    kmax = array.first.keys.map(&:to_s).map(&:length).max
    cell_size = (vmax > kmax ? vmax : kmax) + 1

    # Print keys from first item in array
    keys_to_print = metrics_table_headers(array.first.keys, cell_size)

    left_indent = INDENT * indent # ' ' * cell_size * indent
    print ("\n" + left_indent + keys_to_print.join('')).send(color)

    array.each do |row|
      values_to_print = row.values.map do |value|
        (value.to_s + ' ' * (cell_size - value.to_s.length)).send(color)
      end
      print ("\n" + INDENT * indent + values_to_print.join('')).send("light_#{color}")
    end
  end
end
