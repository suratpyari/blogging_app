class Admin::BaseController < ApplicationController

  before_filter :find_user 
  layout 'admin'

end
