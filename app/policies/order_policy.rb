class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.admin?
  end

  def show?
    user.admin? || user.id == record.user_id
  end

  def edit?
    user.admin? || user.id == record.user_id
  end

  def update?
    user.admin? || user.id == record.user_id
  end

  def create?
    user.admin? || user.id == record.user_id
  end

  def destroy?
    user.admin? || user.id == record.user_id
  end
end
