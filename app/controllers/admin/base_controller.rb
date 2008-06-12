class Admin::BaseController < ApplicationController

  before_filter :find_user#, :only => 'base/index' 
  layout 'admin'

  def index
 p "i am in index"
  end
end
