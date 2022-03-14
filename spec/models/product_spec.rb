require 'rails_helper'

RSpec.describe Product, type: :model do
  
  # memoized helper method
  let(:category) {
    Category.create(name: "category_test")
  }

  # explicit subject 
  subject {
    category.products.create(
      name: "product1",
      quantity: 4,
      price_cents: 321,
    )
  }

  describe "Validations" do
    it "validates with valid attributes" do
      expect(subject).to be_valid
      expect(subject.errors.full_messages).to be_empty
    end

    it "does not validate without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include "Name can't be blank"
    end

    it "does not validate without a quantity" do
      subject.quantity = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include "Quantity can't be blank"
    end

    it "does not validate without a price" do
      subject.price_cents = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include "Price can't be blank"
    end

    it "does not validate without a category" do
      product = Product.create(
        name: "product_test",
        price_cents: 123,
        quantity: 1,
      )
      expect(product).to_not be_valid
      expect(product.errors.full_messages).to include "Category can't be blank"
    end
  end
end