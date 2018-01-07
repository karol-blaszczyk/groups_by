require "rGrouper/version"
require 'colorize'

class RGrouper

  INDENT = "\t"

  class TestSummarizer

    # @return [Hash]
    def self.summarize(metrics)
      {
        cost: metrics.map{|m| m[:cost].to_f}.reduce(&:+),
        views: metrics.map{|m| m[:views].to_f}.reduce(&:+),
      }
    end

  end

  def group(source, *props)
    grouping_by = props.first

    # Swithc case
    group_lambda =
      if grouping_by.is_a?(Symbol) || grouping_by.is_a?(String)
        instance_exec do # Otherwise grouping_by name will be out of lamdda scope
          ->(el) { el[grouping_by] }
        end
      else
        grouping_by
      end

    groups = source.group_by do |el, va|
      group_lambda.call(el) || 'nil'
    end

    # groups = group_by(&props.first)
    groups[:totals] = TestSummarizer.summarize(groups.values.flatten)

    if props.count == 1
      # groups
      groups.merge(groups.reject{|k,_v| k == :totals}) do |group, elements|
        {
          values: elements
        }.tap do |hsh|
          # totals only if more than 1 element
          hsh.merge!(totals: TestSummarizer.summarize(elements)) if elements.count > 1
        end
      end
    else
      groups.merge(groups.reject{|k,_v| k == :totals}) do |group, elements|
        group(elements, *props.drop(1))
      end
    end
  end

  def arr_to_pritty(v, indent, color = 'green')
    vmax = v.flat_map(&:values).map(&:to_s).map(&:length).max # find max value might be slow
    kmax = v.first.keys.map(&:to_s).map(&:length).max
    cell_size = (vmax > kmax ? vmax : kmax) + 1

    keys_to_print = v.first.keys.map do |key|
      key.to_s.upcase + ' ' * ( cell_size - key.to_s.length )
    end
    print ("\n" + INDENT * indent + keys_to_print.join('')).send(color)

    v.each do |row|
      values_to_print  = row.values.map do |value|
        (value.to_s + ' ' * ( cell_size - value.to_s.length )).send(color)
      end
      print ("\n" + INDENT * indent + values_to_print.join('')).send("light_#{color}")
    end
  end

  # @param source [Array<Hash>]
  def pritify(source, indent = 0)
      indent+=1
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

  def print_or_pritify(source)

  end

end
