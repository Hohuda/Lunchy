class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  # Policies for index and today actions
  %i[index? today? for_day?].each do |policy|
    define_method policy.to_s do
      user.admin?
    end
  end

  # Other actions policies
  same_policies = %i[show? create? update? destroy? new? edit? submit?]

  same_policies.each do |policy|
    define_method policy.to_s do
      user.admin? || user.id == record.user_id
    end
  end
end
