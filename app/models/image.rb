class Image < ActiveRecord::Base
  attr_accessible :file
  mount_uploader :file, AvatarUploader
  belongs_to :imageable, :polymorphic => true
end
