require 'rails_helper'

RSpec.describe Victual, type: :model do
  describe 'associations' do
    it { should have_many(:category_items).class_name('CategoryItem') }
    it { should have_many(:categories).class_name('Category') }
  end
  
  describe 'db columns' do
    it { should have_db_index([:name, :price]).unique }
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:price).of_type(:decimal).with_options(null: false) }
    it { should have_db_column(:avatar).of_type(:string)}
  end
  
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0.1).is_less_than_or_equal_to(100) }

    it {
      create(:victual)
      should validate_uniqueness_of(:name).scoped_to(:price)
    }
  end
  
  describe 'categories' do
    before(:each) do
      @categories = create_list(:category, 5)
    end
    
    let(:victual) { create(:victual) }
    
    it 'should change categories by ids' do
      def ids
        victual.category_ids
      end
      expect(ids).not_to include(Category.ids)
      victual.set_categories(Category.ids)
      expect(ids).to match(Category.ids)
      victual.set_categories(Category.ids.first)
      expect(ids).to contain_exactly(Category.ids.first)
    end
  end

  it 'should have carrierwave uploader mounted' do
    victual = Victual.new
    expect(victual.avatar).to be_kind_of(AvatarUploader)
  end
end
