class Admin::BaseController < ApplicationController

  before_filter :use_sitealizer

  before_filter :find_user
  layout 'admin'

  before_filter :put_method, :only => :update
  before_filter :delete_method, :only => :destroy

end
