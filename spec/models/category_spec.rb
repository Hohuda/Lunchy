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
    it { should validate_presence_of(:name) }
    it {
      create(:category)
      should validate_uniqueness_of(:name).case_insensitive
    }
  end

  describe 'scopes' do
    default_categories = %w[first_course main_course drink]

    default_categories.each do |category_name|
      it "should have #{category_name} scope" do
        category = create(:category, name: category_name.humanize)
        scope = Category.public_send(category_name)

        expect(scope).to eq(category)
      end
    end
  end
end
