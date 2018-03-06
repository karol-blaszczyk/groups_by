%w[
  groups_by/version
  colorize
  groups_by/pritifier
  groups_by/core_grouper
  pry
].each do |lib|
  require lib
end

class GroupsBy
  include CoreGrouper

  class << self
    include Pritifier
  end

  # GroupsBy.new.groups_by(
  #   source: DATA,
  #   groupings: [:age_range, :age_range_state, :ad_group_state, :is_negative],
  #   summarizer: nil
  # )
  attr_accessor :source_arr, :groupings, :summarizer
  def groups_by(source_arr, groupings: [], summarizer: nil)
    @source_arr = source_arr
    @groupings = groupings
    @summarizer = summarizer
    group(source_arr, groupings)
  end
end
