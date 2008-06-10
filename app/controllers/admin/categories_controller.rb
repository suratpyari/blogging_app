class Admin::CategoriesController < Admin::BaseController

  before_filter :find_admin, :except => 'index'
  before_filter :find_user, :only => :index

  def index
    @categories = Category.find(:all)
    @category = Category.new if is_admin?
  end

  def create
    @cat = Category.new(params[:category])
    render :update do |page|
      if @cat.save
        page.insert_html :bottom, :categories, :partial => 'category'
        page.form.reset('category_form')
        page.replace_html :flash, "New category created"
        page.replace_html :category_error, ''
      else
        page.replace_html :category_error, @cat.errors.full_messages.join('<br />')
      end
    end
  end

  def delete
    categories = params[:selected]
    if categories.nil?
      msg = "Select category to delete"
    else
      for category in categories
        cat = Category.find(category.to_i)
        if cat.category_name == 'Uncategorized'
          msg = "Can not delete category Uncategorized.<br />"
        else
          cat.destroy
          msg = msg+"Selected categories has been deleted.<br />"
        end
      end
    end
    flash[:msg] = msg
    redirect_to admin_categories_path
  end

  def edit
    @category = Category.find(params[:id])
    render :update do |page|
      page.replace :catform, :partial => 'edit_form'
      page.replace "category-#{@category.id}", ""
    end
  end

  def update
    @category = Category.find(params[:id])
    @category.update_attributes(params[:category])
    redirect_to admin_categories_path
  end

  def cancel
    redirect_to admin_categories_path
  end

end