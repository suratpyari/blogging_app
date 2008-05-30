# == Schema Information
# Schema version: 11
#
# Table name: categories
#
#  id            :integer(11)     not null, primary key
#  category_name :string(255)     
#  description   :string(255)     
#  created_at    :datetime        
#  updated_at    :datetime        
#

class Category < ActiveRecord::Base

  has_and_belongs_to_many :posts

  validates_presence_of :category_name
  validates_uniqueness_of :category_name

end
