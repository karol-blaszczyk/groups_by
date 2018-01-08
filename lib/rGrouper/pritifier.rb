module Pritifier
  require 'colorize'
  INDENT = "\t".freeze
  require 'pry'
  #
  def print_headers(keys, cell_size)
    keys.map do |key|
      key.to_s.upcase + ' ' * (cell_size - key.to_s.length)
    end
  end

  def arr_to_pritty(array, indent, color = 'green')
    vmax = array.flat_map(&:values).map(&:to_s).map(&:length).max # find max value might be slow
    kmax = array.first.keys.map(&:to_s).map(&:length).max
    cell_size = (vmax > kmax ? vmax : kmax) + 1

    # Print keys from first item in array
    keys_to_print = print_headers(array.first.keys, cell_size)

    print ("\n" + ' ' * cell_size * indent + keys_to_print.join('')).send(color)

    array.each do |row|
      values_to_print = row.values.map do |value|
        (value.to_s + ' ' * (cell_size - value.to_s.length)).send(color)
      end
      print ("\n" + ' ' * cell_size * indent + values_to_print.join('')).send("light_#{color}")
    end
  end

  # @param source [Array<Hash>]
  def pritify(source, indent = 0)
    indent += 1
    source.each do |k, v|
      # indent = 0 unless i == 0
      if k == :values
        arr_to_pritty(v, indent, 'green')
      elsif k == :totals
        arr_to_pritty([v], indent, 'blue')
      else
        print "\n" + INDENT * indent + k.to_s.underline.red
        pritify(v, indent)
      end
    end
  end

  def print_or_pritify(source); end
end
