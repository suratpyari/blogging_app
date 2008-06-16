require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  fixtures :users

  def test_invalid_with_empty_attributes
    user = User.new(:email => "")
    assert !user.valid?
    assert user.errors.invalid?(:first_name)
    assert user.errors.invalid?(:username)
    assert user.errors.invalid?(:email)
  end

  def test_invalid_empty_password
    user = User.new(:hashed_password  => "")
    assert !user.valid?
    assert_equal "password cannot be blank" , user.errors.on(:base)
  end

  def test_unique_username
    user = User.new(:first_name     => "vibha",
                  :last_name        => "chadha",
                  :email            => "vibha@vinsol.com",
                  :salt             => "57657654",
                  :hashed_password  => User.encrypted_password("vibha", "57657654"),
                  :role             => 1,
                  :status           => 0,
                  :biodata          => "")
    user.username = users(:surat_pyari).username
    assert !user.save
    assert user.errors.invalid?(:username)
    assert_equal "has already been taken" , user.errors.on(:username)
  end

  def test_unique_email
    user = User.new(:first_name     => "vibha",
                  :last_name        => "chadha",
                  :email            => users(:surat_pyari).email,
                  :salt             => "57657654",
                  :hashed_password  => User.encrypted_password("vibha", "57657654"),
                  :role             => 1,
                  :status           => 0,
                  :biodata          => "")
    user.username = "vibha"
    assert !user.save
    assert user.errors.invalid?(:email)
    assert_equal "has already been taken" , user.errors.on(:email)
  end

  def test_protected_username
    user = User.new(:first_name     => "surat",
                  :last_name        => "pyari",
                  :email            => "surat@vinsol.com",
                  :salt             => "57657654",
                  :hashed_password  => User.encrypted_password("surat", "57657654"),
                  :username         => "surat",
                  :role             => 1,
                  :status           => 0,
                  :biodata          => "")
    assert !user.save
    assert user.errors.invalid?(:username)
    assert_equal "can't be blank" , user.errors.on(:username)
  end

  def test_format_email
    user1 = User.new(:email => "suratpyari")
    assert !user1.save
    assert_equal "is invalid" , user1.errors.on(:email)

    user2 = User.new(:email => "suratpyari@vinsol")
    assert !user2.save
    assert_equal "is invalid" , user2.errors.on(:email)

    user3 = User.new(:email => "surat@vinsol.com")
    assert !user3.save
    assert_nil(user3.errors.on(:email))

    user4 = User.new(:email => "")
    assert !user4.save
    assert_equal "can't be blank" , user4.errors.on(:email)
  end

  def test_authenticate
    assert_equal false, User.authenticate("wrongusername", "wrongpassword")
    assert_equal nil, User.authenticate("suratpyari", "wrongpassword")
    assert_equal users(:surat_pyari), User.authenticate("suratpyari", "suratpyari")
  end

  def test_image
    user = users(:surat_pyari)
    assert_equal "/images/default.jpg", user.image
    File.new("public/images/profile_images/suratpyari.jpg")
    assert_equal "public/images/profile_images/suratpyari.jpg", user.image
    File.delete("public/images/profile_images/suratpyari.jpg")
  end

  def test_name
    assert_equal "surat pyari", users(:surat_pyari).name
    assert_equal "admin", users(:admin).name
  end

#  def test_before_destroy
#    File.new("public/images/profile_images/suratpyari.jpg", "w+")
#    users(:surat_pyari).destroy
#    assert_equal false, File.exist?("public/images/profile_images/suratpyari.jpg")
#  end

end
