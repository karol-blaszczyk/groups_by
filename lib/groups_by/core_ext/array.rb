require 'groups_by'

class Array
  def groups_by(*grouping_rules)
    GroupsBy.new.groups_by(self, group_by_rules: grouping_rules)
  end
end
