%w[
  rGrouper/version
  colorize
  rGrouper/pritifier
  rGrouper/core_grouper
  pry
].each do |lib|
  require lib
end

class RGrouper
  include CoreGrouper

  class << self
    include Pritifier
  end

  # RGrouper.new.rgroup_by(
  #   source: DATA,
  #   groupings: [:age_range, :age_range_state, :ad_group_state, :is_negative],
  #   summarizer: nil
  # )
  attr_accessor :source_arr, :groupings, :summarizer
  def rgroup_by(source_arr, groupings: [], summarizer: nil)
    @source_arr = source_arr
    @groupings = groupings
    @summarizer = summarizer
    group(source_arr, groupings)
  end
end
