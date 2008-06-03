class AdminUser < ActiveRecord::Migration
  def self.up
    user=User.new(:first_name => "admin", :last_name => "" ,:email => "admin@gmail.com", :role => 1, :password => "admin", :password_confirmation => "admin")
    user.save(false)
  end

  def self.down
    User.destroy_all "email = 'admin@gmail.com'"
  end
end
