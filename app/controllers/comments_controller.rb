class CommentsController < ApplicationController
#include ActionView::Helpers::ActiveRecordHelper
  # Creates a new comment and set status as 0
  include SimpleCaptcha::ViewHelpers

  # Creates a new comments
  # Set status = 2 if comment looks like a spam else 0
  def create
    post = Post.find(params[:post_id])
    @comment = Comment.new(params[:comment])
    post.comments << @comment
    simple_captcha_valid? ? @comment.status = 2 : @comment.status = 0
    if post.save
      msg = @comment.status == 2 ? "Your comment looks like spam and will show up once admin approves" : "This comment has been submitted"
      render :update do |page|
        page.replace_html :comment_errors, ''
        page.form.reset('comment_form')
        page.replace_html :captcha , "#{show_simple_captcha}"
        page.replace_html :flash , msg
      end
    else
      render :update do |page|
        page.replace_html :comment_errors, @comment.errors.full_messages.join('<br />')
        page.replace_html :comment_form, :partial => 'comments/form'
        page.replace_html :captcha , "#{show_simple_captcha}"
      end
    end
  end
  
  def preview
    render :layout => false
  end

end
