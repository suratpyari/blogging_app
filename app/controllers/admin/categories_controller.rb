class Admin::CategoriesController < Admin::BaseController

  before_filter :find_admin, :except => 'index'

  def index
    @categories = Category.find(:all)
    if is_admin?
      @category = Category.new
    end
  end

  def create
    @cat = Category.new(params[:category])
    render :update do |page|
      if @cat.save
        flash[:msg] = "New category created"
        page.insert_html :bottom, :categories, :partial => 'category'
        page.form.reset('category_form')
        page.replace_html :flash, flash[:msg]
        page.replace_html :category_error, ''
      else
        page.replace_html :category_error, @cat.errors.full_messages.join('<br />')
      end
    end
  end

  def delete
    categories = params[:selected]
    msg = ""
    for category in categories
      cat = Category.find(category.to_i) rescue nil
      if cat.category_name == 'Uncategorized'
        msg = msg+"can not delete category Uncategorized<br />"
      else
        cat.destroy
        msg = msg+"#{cat.category_name} deleted<br />"
      end
    end
    flash[:msg] = msg
    redirect_to admin_categories_path
  end

  def edit
    @category = Category.find(params[:id])
    render :update do |page|
      page.replace :catform, :partial => 'edit_form'
    end
  end

  def update
    @category = Category.find(params[:id])
    @category.update_attributes(params[:category])
    redirect_to admin_categories_path
  end

end
