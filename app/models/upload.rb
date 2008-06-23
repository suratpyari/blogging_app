# == Schema Information
# Schema version: 15
#
# Table name: uploads
#
#  id           :integer(11)     not null, primary key
#  parent_id    :integer(11)     
#  content_type :string(255)     
#  filename     :string(255)     
#  thumbnail    :string(255)     
#  size         :integer(11)     
#  width        :integer(11)     
#  height       :integer(11)     
#  post_id      :integer(11)     
#  created_at   :datetime        
#  updated_at   :datetime        
#

class Upload < ActiveRecord::Base
  
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => 500.kilobytes,
                 :resize_to => '320x200>',
                 :thumbnails => { :thumb => '100x100>' }

  validates_as_attachment

  

end
