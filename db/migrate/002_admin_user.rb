class AdminUser < ActiveRecord::Migration
  def self.up
    User.create(:first_name => "admin", :last_name => "" ,:email => "admin@gmail.com", :role => 1, :password => "admin", :password_confirmation => "admin")
  end

  def self.down
    User.destroy_all "first_name = 'admin'"
  end
end
