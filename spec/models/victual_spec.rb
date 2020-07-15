# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Victual, type: :model do
  describe 'associations' do
    it { should have_many(:category_items).class_name('CategoryItem') }
    it { should have_many(:categories).class_name('Category') }
    it { should have_many(:menu_items).class_name('MenuItem') }
    it { should have_many(:menus).class_name('Menu') }
  end

  describe 'db columns' do
    it { should have_db_index(%i[name price]).unique }
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:price).of_type(:decimal).with_options(null: false) }
    it { should have_db_column(:avatar).of_type(:string) }
  end

  describe 'validations' do
    let!(:victual) { create(:victual) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0.1).is_less_than_or_equal_to(100) }
    it { should validate_uniqueness_of(:name).scoped_to(:price) }
  end

  describe 'instance methods' do
    let(:victual) { create(:victual) }
    let!(:categories) { create_list(:category, 5) }

    it 'should set victuals by ids' do
      victual.set_categories(Category.ids)
      expect(victual.category_ids).to match(Category.ids)
      victual.set_categories(Category.ids.first)
      expect(victual.category_ids).to contain_exactly(Category.ids.first)
    end
  end
  
  describe 'class methods' do
    describe 'search_victuals_by_params(params)' do
      let!(:victual) { create_victual_with_categories(categories_count: 1) }
      let(:category) { victual.categories.take }
      let(:params) { { category_id: category.id } }

      subject { Victual.search_victuals_by_params(params).first.take }

      it 'should search victuals by category id' do
        expect(subject).to match(category.victuals.take)
      end
    end
  end
end
