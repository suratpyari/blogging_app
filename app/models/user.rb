
class User < ActiveRecord::Base
  
  has_many :posts

  ROLE = [["Admin", 1], ["User", 2]]

  # username can not be changed
  attr_protected :username
  validates_presence_of :first_name, :email, :username
  validates_uniqueness_of :username, :email
  attr_accessor :password_confirmation
  validates_confirmation_of :password

  # validates if password is blank or not 
  def validate
    errors.add_to_base("password cannot be blank") if hashed_password.blank?
  end

  # When user tries to login checks user with given username and password exists or not
  # and returns user else return false  
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
    self.salt = rand.to_s #creates salt by generating random number
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  # saves uploaded picture in public/images with name of username
  def uploaded_pic_file=(pic_file)
    if !pic_file.blank?
      img = Magick::Image.from_blob(pic_file.read).first
      img.change_geometry!('100x100'){ |cols, rows, im|
        im.resize!(cols, rows)
      }
      new_file = "public/images/profile_images/#{self.username}.jpg"
      img.write(new_file)
    end
  end
  
  # returns path of picture of picture exists else return path of default picture
  def image
    if File.exist?("public/images/profile_images/#{self.username}.jpg")
      img_path = "/images/profile_images/#{self.username}.jpg"
    else
      img_path = "/images/profile_images/default.jpg"
    end
    return img_path
  end

  # deletes the picture of user in public/images when user is deleted
  def after_destroy
    File.delete("public/images/#{self.username}.jpg") if File.exist?("public/images/#{self.username}.jpg")
  end

  def name
    self.first_name+' '+self.last_name
  end

  private

  # encrypt password using salt  
  def self.encrypted_password(password, salt)
    new_string = password+salt
    Digest::SHA1.hexdigest(new_string)
  end
end
