class UsernameForAdmin < ActiveRecord::Migration
  def self.up
    user=User.find_by_email("admin@gmail.com")
    user.update_attribute('username', 'admin')
  end

  def self.down
    User.destroy_all "username = 'admin'"
  end
end
