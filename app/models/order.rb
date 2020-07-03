class Order < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  belongs_to :user
  belongs_to :menu

  has_many :order_items
  has_many :menu_items, through: :order_items
  has_many :victuals, through: :menu_items

  validates :user_id, presence: true
  validates :menu_id, presence: true
  validates :total_cost, presence: true

  before_save :calculate_total_cost
  before_validation :add_default_menu, if: Proc.new { |order| order.menu.nil?}

  # Returnes orders with specified created date 
  def self.search_by_date(date)
    date = Date.parse(date)
    where(created_at: date.beginning_of_day..date.end_of_day)
  end

  # Count total cost of orders
  def self.count_total_cost
    result = 0
    find_each do |order|
      result += order.total_cost
    end
    return result
  end

  # Changes victuals in order
  def change_victuals(ids)
    if ids.is_a? Enumerable
      ids.filter!{|i| i unless i.blank?}
      comparison = (victuals.ids <=> ids)
      if comparison == 1
        diff = victuals.ids - ids
        remove_items Victual.find(diff)
      elsif comparison == -1
        diff = ids - victuals.ids
        add_items Victual.find(diff)
      end
    else
      false                    #<<<<<------Rework for exception probably
    end
  end

  # Adds item/items  to order
  def add_items(collection)
    if collection.is_a? Enumerable
      collection.each do |item|
        add_item(item)
      end
    else
      add_item(collection)
    end
    save
  end

  # Changes submit field
  def submit
    self.editable = false
    save
  end

  def editable?
    return editable
  end
  
  # Removes item/items from order
  def remove_items(collection)
    if collection.is_a? Enumerable
      collection.each do |item|
        remove_item item
      end
    else
      remove_item collection
    end
  end
  
  private
  
    # Calculates total cost of order by victual prices
    def calculate_total_cost
      self.total_cost = victuals.sum("price")
    end
  
    # Adds menu to orders where menu wasn't specified 
    def add_default_menu
      today_menus = Menu.today_menus
      if today_menus.any?
        self.menu = today_menus.first
      end
    end
    
    #Adds item to order
    def add_item(item)
      if item.is_a? Victual
        add_victual(item)
      elsif item.is_a? MenuItem
        add_menu_item(item)
      else
        puts 'Argument type mismatch'
        return false
      end
    end
    
    # Adds victual to order
    def add_victual(victual)
      item = menu.menu_items.find_by(victual_id: victual.id)
      if item.nil?
        puts 'No such menu item'
        return false
      else
        add_menu_item(item)
      end
    end
    
    # Adds menu_item to order
    def add_menu_item(item)
      order_item = order_items.find_by(menu_item_id: item.id)
      if order_item.nil?
        if menu.menu_items.include?(item)
          menu_items << item
        else
          puts 'No such menu item'
          return false
        end
      else
        order_item.quantity += 1
        order_item.save
      end
    end
    
    # Removes item from order
    def remove_item(item)
      if item.is_a? Victual
        remove_victual(item)
      elsif item.is_a? MenuItem
        remove_menu_item(item)
      else
        puts 'Argument type mismatch'
        return false
      end
    end

    # Removes victual from order
    def remove_victual(victual)
      item = menu_items.find_by(victual_id: victual.id)
      if item.nil?
        puts 'No such item in order'
        return false
      else
        remove_menu_item(item)
      end
    end
    
    # Removes menu_item from order
    def remove_menu_item(item)
      if menu_items.include?(item)
        order_item = order_items.find_by(menu_item: item)
        if order_item.quantity > 1
          order_item.quantity -= 1
          order_item.save
        else
          order_items.delete(order_item)
        end
      else
        puts 'No such item in order'
        return false
      end
    end

end
