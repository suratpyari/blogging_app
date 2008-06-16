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

  def test_accepted_comments
    post = posts(:post1)
    assert_equal comments(:comment_status_1), post.accepted_comments
  end
end
