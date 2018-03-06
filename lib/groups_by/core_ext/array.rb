require 'groups_by'

class Array
  def groups_by(*grouping_rules)
    GroupsBy.new.groups_by(self, groupings: grouping_rules)
  end
end
