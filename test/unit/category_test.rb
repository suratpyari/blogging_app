require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < ActiveSupport::TestCase
  
  fixtures :categories

  def test_invalid_with_empty_attributes
    category = Category.new()
    assert !category.valid?
    assert category.errors.invalid?(:category_name)
  end

  def test_unique_username
    category = Category.new(:category_name => categories(:category1).category_name)
    assert !category.save
    assert user.errors.invalid?(:category_name)
    assert_equal "has already been taken" , user.errors.on(:category_name)
  end

#  def test_defore_destroy
#    post = posts(:post1)
#    category = Category.create(:category_name => "category_to_destroy")
#    post.categories << category

#    assert_equal categories(:category_uncategorized), post.categories
#  end

end
