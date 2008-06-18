class CommentsController < ApplicationController
#include ActionView::Helpers::ActiveRecordHelper
  # Creates a new comment and set status as 0
  include SimpleCaptcha::ViewHelpers
  def create
    post = Post.find(params[:post_id])
    @comment = Comment.new(params[:comment])
    post.comments << @comment
    if simple_captcha_valid?  
      @comment.status = 2
    else
      @comment.status = 0
    end
    if post.save
      if @comment.status == 2
        msg = "Your comment looks like spam and will show up once admin approves"
      else
        msg = "This comment has been submitted"
      end
      render :update do |page|
        page.replace_html :comment_errors, ''
        page.form.reset('comment_form')
        page.replace_html :captcha , "#{show_simple_captcha}"
        page.replace_html :flash , msg
      end
    else
      render :update do |page|
        page.replace_html :comment_errors, @comment.errors.full_messages.join('<br />')
        page.replace_html :captcha , "#{show_simple_captcha}"
      end
    end
  end

end
