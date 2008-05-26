
class User < ActiveRecord::Base

  ROLE = [["Admin", 1], ["User", 2]]

  attr_protected :username
  validates_presence_of :first_name, :email, :username
  validates_uniqueness_of :username, :email
  attr_accessor :password_confirmation
  validates_confirmation_of :password

  def validate
    errors.add_to_base("password can't be blank") if hashed_password.blank?
  end
  
  def self.authenticate(username, password)
    user = self.find_by_username(username)
    return false unless user
    user = nil unless user.hashed_password == encrypted_password(password, user.salt)
    return user
  end
  
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    self.salt = rand.to_s
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  def uploaded_pic_file=(pic_file)
    if !pic_file.blank?
      img = Magick::Image.from_blob(pic_file.read).first
      img.change_geometry!('100x100'){ |cols, rows, im|
        im.resize!(cols, rows)
      }
      new_file="public/images/#{self.username}.jpg"
      img.write(new_file)
    end
  end

  def after_destroy
    File.delete("public/images/#{self.username}.jpg") if File.exist?("public/images/#{self.username}.jpg")
  end

  private
  
  def self.encrypted_password(password, salt)
    new_string = password+salt
    Digest::SHA1.hexdigest(new_string)
  end
end
