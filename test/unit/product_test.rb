require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end
  
  test "product price must be positive" do
    product = Product.new(:title => "My test title", :description => "My test description", :image_url => "test.jpg")
    
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')
    
    product.price = 0 
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')
    
    product.price = 1
    assert product.valid?
  end
  
  def new_product(image_url)
    Product.new(:title => "My book", :description => "yyyy", :price => 1, :image_url => image_url)
  end
  
  test "image url" do 
    ok = %w{ fred.jpg fred.png fred.gif FRED.JPG FrEd.pNg http://fs/asf/asfd/asf/fe.jpg }
    bad= %w{ fred.doc fred.gif/more fred.jpg.php }
    
    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end
    
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end
  
  test "product is not valid without a unique title" do
    product = Product.new(:title => products(:java).title, :description => "yyy", :price => 9.99, :image_url => 'sa.jpg')
    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join('; ')
  end
end
