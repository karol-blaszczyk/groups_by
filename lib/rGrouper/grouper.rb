module Grouper
  # -> (metrics) do
  #   {
  #     cost: metrics.map { |m| m[:cost].to_f }.reduce(&:+),
  #     views: metrics.map { |m| m[:views].to_f }.reduce(&:+)
  #   }
  # end
  class TestSummarizer
    # @return [Hash]
    def self.summarize(metrics)
      {
        cost: metrics.map { |m| m[:cost].to_f }.reduce(&:+),
        views: metrics.map { |m| m[:views].to_f }.reduce(&:+)
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

    groups = source.group_by do |el, _va|
      group_lambda.call(el) || 'nil'
    end

    # groups = group_by(&props.first)
    groups[:totals] = TestSummarizer.summarize(groups.values.flatten)

    if props.count == 1
      # groups
      groups.merge(groups.reject { |k, _v| k == :totals }) do |_group, elements|
        {
          values: elements
        }.tap do |hsh|
          # totals only if more than 1 element
          hsh.merge!(totals: TestSummarizer.summarize(elements)) if elements.count > 1
        end
      end
    else
      groups.merge(groups.reject { |k, _v| k == :totals }) do |_group, elements|
        group(elements, *props.drop(1))
      end
    end
  end
end
