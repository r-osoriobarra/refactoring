class Category < ApplicationRecord
  has_and_belongs_to_many :products

  has_many :sub_categories, class_name: "Category", foreign_key: "category_id", dependent: :destroy
  belongs_to :main_category, class_name: "Category", foreign_key: "category_id", optional: true

  #Parent scope
  scope :main_categories, -> { where(category_id: nil) }

  #Subcategories scopes
  scope :subcategories, -> { where.not(category_id: nil) }

  def self.sons_categories
    @parents_id = Category.main_categories.pluck(:id)
    @subcategories = Category.subcategories
    @sons = Array.new

    @subcategories.each do |category|
      if category.category_id.in? @parents_id
        @sons << category
      end 
    end
    return @sons
  end

  def self.grandsons
    @subcategories = Category.subcategories
    @sons = Category.fabilocos_sons
    @sons_ids = @sons.pluck(:id)
    @grandsons = Array.new

    @subcategories.each do |category|
      if category.category_id.in? @sons_ids
        @grandsons << category
      end
    end
    return @grandsons
  end
end
