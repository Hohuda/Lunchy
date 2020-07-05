class Order < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  belongs_to :user
  belongs_to :menu

  has_many :order_items, dependent: :destroy
  has_many :menu_items, through: :order_items
  has_many :victuals, through: :menu_items

  validates :user_id, presence: true
  validates :menu_id, presence: true
  validates :total_cost, presence: true

  before_save :calculate_total_cost
  before_validation :add_default_menu, if: proc { |order| order.menu.nil? }

  include SetAssociations
  create_set_association_method_for(MenuItem)

  # Wrapper for set_menu_items to create set_victuals
  def set_victuals(*ids)
    new_ids = menu.victual_ids & ids.flatten.map(&:to_i)
    sql = <<-SQL

      SELECT menu_items.id
      FROM menus INNER JOIN menu_items
      ON menus.id = menu_items.menu_id
      INNER JOIN victuals
      ON menu_items.victual_id = victuals.id
      WHERE menus.id = #{menu.id}
      AND victuals.id in (#{new_ids.join(', ')})
    SQL
    query_result = ActiveRecord::Base.connection.execute(sql)
    new_ids = query_result.values.flatten
    set_menu_items(new_ids)
  end

  # Returnes orders with specified created date
  def self.search_by_date(date)
    date = Date.parse(date)
    where(created_at: date.beginning_of_day..date.end_of_day)
  end
  
  # Count total income of orders relation (probably useless)
  def self.calculate_total_income
    self.sum('total_cost')
  end
  
  # Changes submit field
  def submit
    self.update(editable: false)
  end

  def editable?
    editable
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
end
