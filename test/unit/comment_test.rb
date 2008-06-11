require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase

  def test_invalid_with_empty_attributes
    comment = Comment.new()
    assert !comment.valid?
    assert comment.errors.invalid?(:author)
    assert comment.errors.invalid?(:content)
    assert comment.errors.invalid?(:email)
  end

  def test_format_email
    comment1 = Comment.new(:email => "suratpyari")
    assert !comment1.save
    assert_equal "is invalid" , comment1.errors.on(:email)

    comment2 = Comment.new(:email => "suratpyari@vinsol")
    assert !comment2.save
    assert_equal "is invalid" , comment2.errors.on(:email)

    comment3 = Comment.new(:email => "suratpyari@vinsol.com")
    assert !comment3.save
    assert_nil(comment3.errors.on(:email))

    comment4 = Comment.new(:email => "")
    assert !comment4.save
    assert_equal "can't be blank" , comment4.errors.on(:email)
  end

end
