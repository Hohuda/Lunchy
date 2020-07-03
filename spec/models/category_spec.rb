require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it { should have_many(:category_items).class_name('CategoryItem') }
    it { should have_many(:victuals).class_name('Victual') }
  end

  describe 'db columns' do
    it {
      should have_db_column(:name).
        of_type(:string).
        with_options(null: false, unique: true)
    }
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

      it 'should return first course category' do
        subject.should eq(categories(:first_course))
      end
    end

    context 'main course category scope' do
      subject { Category.main_course }

      it 'should return main course category' do
        subject.should eq(categories(:main_course))
      end
    end

    context 'drink category scope' do
      subject { Category.drink }

      it 'should return drink category' do
        subject.should eq(categories(:drink))
      end
    end
  end
end
