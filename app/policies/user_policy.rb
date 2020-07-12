class UserPolicy < ApplicationPolicy
  # class Scope < Scope
  #   def resolve
  #     if user.admin?
  #       scope.all
  #     end
  #   end
  # end

  def index?
    user.admin?
  end

  def show?
    user.admin? || user.id == record.id
  end
end
