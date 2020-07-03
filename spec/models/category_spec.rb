require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it { should have_many(:category_items).class_name('CategoryItem') }
    it { should have_many(:victuals).class_name('Victual') }
  end

  describe 'db columns' do
    it { should have_db_column(:name).of_type(:string).with_options(null: false, unique: true) }
  end

  describe 'validations' do 
    Category.create name: 'to resolve PG not null constraint error'

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'scopes' do
    fixtures :categories

    context 'first course category scope' do
      subject { Category.first_course }

      it { is_expected.to eq(categories(:first_course)) }
    end

    context 'main course category scope' do
      subject { Category.main_course }

      it { is_expected.to eq(categories(:main_course)) }
    end

    context 'drink category scope' do
      subject { Category.drink }

      it { is_expected.to eq(categories(:drink)) }
    end
  end
end
