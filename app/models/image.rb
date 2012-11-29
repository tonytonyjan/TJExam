class Image < ActiveRecord::Base
  attr_accessible :file, :remote_file_url
  mount_uploader :file, ImageUploader
  belongs_to :imageable, :polymorphic => true
end
