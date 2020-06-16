class OrderValidator < ActiveModel::Validator
  def validate(record)
    unless record.menu.created_at.today?
      record.errors[:created_at] << 'Create order with present menus.'
    end
  end
end