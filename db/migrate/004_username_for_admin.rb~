class UsernameForAdmin < ActiveRecord::Migration
  def self.up
    User.destroy_all "email = 'admin@gmail.com'"
    User.create(:first_name => "admin", :last_name => "" ,:username => "admin", :email => "admin@gmail.com", :role => 1, :password => "admin", :password_confirmation => "admin")
  end

  def self.down
    User.destroy_all "username = 'admin'"
  end
end
