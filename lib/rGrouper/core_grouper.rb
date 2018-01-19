module CoreGrouper
  UNDEFINED_GROUP_NAME = 'undefined'.freeze

  # @param source [Array<Hash>]
  def group(source, groupings)
    groups = source.group_by { |el| group_proc(groupings.first).(el) || UNDEFINED_GROUP_NAME }

    groups.merge!(totals: summarizer.(groups.values.flatten)) if summarizer

    totals_reject = -> (k, _v){ k == :totals }

    groups.merge(groups.reject(&totals_reject)) do |_group, elements|
      if groupings.count == 1
        { values: elements }.tap do |hsh|
          # totals only if more than 1 element
          hsh.merge!(totals: summarizer.(elements)) if elements.count > 1 && summarizer
        end
      else
        group(elements, groupings.drop(1))
      end
    end
  end

  private

  # @param grouping_by [Proc,String,Symbol]
  # @return [Proc]
  def group_proc(grouping_by)
    case grouping_by
    when Symbol, String
      # Otherwise grouping_by name will be out of lambda scope
      instance_exec { ->(el) { el[grouping_by] } }
    when Proc
      grouping_by
    else
      raise 'InvalidGrouping'
    end
  end
end
