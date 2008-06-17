require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase

  fixtures :posts

  def test_invalid_with_empty_attributes
    post = Post.new()
    assert !post.valid?
    assert post.errors.invalid?(:title)
    assert post.errors.invalid?(:content)
  end

  def test_unique_postname
    post = Post.new(:title => posts(:post1).title,
                    :content => "some content",
                    :user_id => 1,
                    :status => 1)
    assert !post.save
    assert post.errors.invalid?(:title)
    assert_equal "has already been taken" , post.errors.on(:title)
  end

  def test_before_destroy
    post1 = posts(:post_published)
    comments = post1.comments
    tagging1 = taggings(:taggings_004)
    tagging2 = taggings(:taggings_002)
    assert post1.taggings.include?(tagging1)
    assert post1.taggings.include?(tagging2)
    post1.destroy
    assert_equal true, Tagging.find_all_by_taggable_id(2).empty?
    assert_equal true, Comment.find_all_by_commentable_id(2).empty?    
  end

end
