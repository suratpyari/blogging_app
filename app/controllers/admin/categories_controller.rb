class Admin::CategoriesController < Admin::BaseController

  skip_before_filter :find_user, :except => 'index'
  before_filter :find_admin, :except => 'index'

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
          msg = "Can not delete category Uncategorized"
        else
          cat.destroy
          msg = "Selected categories has been deleted"
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
      page.replace "category-#{@category.id}", "<div id=category-#{@category.id}></div>"
    end
  end

  def update
    @cat = Category.find(params[:id])
    @cat.update_attributes(params[:category])
    @category = Category.new
    render :update do |page|
      page.replace :catform, :partial => 'form'
      page.replace "category-#{@cat.id}", :partial => 'category'
    end
  end

  def cancel_edit_form
    @cat = Category.find(params[:id])
    @category = Category.new
    render :update do |page|
      page.replace "category-#{@cat.id}", :partial => 'category'
      page.replace :catform, :partial => 'form'
    end
  end

  def cancel_new_form
    @category = Category.new
    render :update do |page|
      page.replace :catform, :partial => 'form'
    end
  end

end
