require File.dirname(__FILE__) + '/../test_helper'

class TagTest < Test::Unit::TestCase
  fixtures :posts  
  def setup
    @obj = Post.find(:first)
    @obj.tag_with "pale imperial"
  end

  def test_to_s
    assert_equal "imperial pale", Post.find(:first).tags.to_s
  end

  def test_cloud
    tags = Tag.cloud
    assert_equal false, tags.nil?
    assert_equal 2, tags.size
  end
  
end
