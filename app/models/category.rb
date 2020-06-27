class Category < ApplicationRecord

  has_many :category_items
  has_many :victuals, through: :category_items

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  def self.first_course
    find_by name: 'First course'
  end

  def self.main_course
    find_by name: 'Main course'
  end
  
  def self.drink
    find_by name: 'Drink'
  end
  
  # Returns categories names
  def self.names
    names = []
    Category.all.each do |category|
      names << category.name
    end
    return names
  end

 # Returns categories by array of categories names
  def self.search_by_names(names)
    categories = []
    # Filters for blank names and search categories by names
    names.filter{|i| i unless i.blank?}.each do |name|
      categories << Category.find_by(name: name)
    end
    # Returns not nil search results
    return categories.filter{|i| i unless i.nil?}
  end

end
