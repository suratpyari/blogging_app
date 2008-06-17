require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < ActiveSupport::TestCase
  
  fixtures :categories, :posts, :categories_posts

  def test_invalid_with_empty_attributes
    category = Category.new()
    assert !category.valid?
    assert category.errors.invalid?(:category_name)
  end

  def test_unique_username
    category = Category.new(:category_name => categories(:category1).category_name)
    assert !category.save
    assert category.errors.invalid?(:category_name)
    assert_equal "has already been taken" , category.errors.on(:category_name)
  end

  def test_defore_destroy
    post = posts(:post1)
    category = categories(:category1)
    assert post.categories.include?(category)
    category.destroy
    post.reload
    assert post.categories.include?(categories(:category_uncategorized))
  end

end
