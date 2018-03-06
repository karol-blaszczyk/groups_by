module CoreGrouper
  UNDEFINED_GROUP_NAME = '_unknown_group_'.freeze

  class InvalidGrouping < StandardError; end

  # @param source [Array<Hash>]
  # @param group_by_rules [Array<String,Symbol,Proc>]
  def group(source, group_by_rules)
    groups = source.group_by { |el| group_proc(group_by_rules.first).call(el) || UNDEFINED_GROUP_NAME }
    return groups.merge(groups) { |_group, elements| group_merger(elements, group_by_rules) } unless summarizer
    # Summarizer present
    groups.merge! totals_hash(groups.values.flatten)
    groups.merge(groups.reject { |k, _v| k == :totals }) do |_group, elements|
      group_merger(elements, group_by_rules)
    end
  end

  private

  def group_merger(elements, group_by_rules)
    return group(elements, group_by_rules.drop(1)) unless group_by_rules.count == 1
    return elements unless summarizer
    # Summarizer present
    { values: elements }.tap do |hsh|
      # totals only if more than 1 element
      hsh.merge!(totals_hash(elements)) if elements.count > 1
    end
  end

  def totals_hash(elements)
    { totals: summarizer.call(elements) }
  end

  # @param grouping_by [Proc,String,Symbol]
  # @return [Proc]
  def group_proc(grouping_by)
    case grouping_by
    when Symbol, String
      # prevent grouping_by to be out of lambda scope
      instance_exec { ->(el) { el[grouping_by] } }
    when Proc
      grouping_by
    else
      raise InvalidGrouping
    end
  end
end
