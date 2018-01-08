%w[
  rGrouper/version
  colorize
  rGrouper/pritifier
  rGrouper/grouper
].each do |lib|
  require lib
end

class RGrouper
  include Pritifier
  include Grouper
end
