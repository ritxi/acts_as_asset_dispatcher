require 'rails/generators'

class AssetsInstallGenerator < Rails::Generators::Base
  
  def create_base_folders

    path_assets = 'assets'
    path_assets_images = File.join(path_assets,'images')
    path_assets_watermarks = File.join(path_assets,'watermarks')
    path_container = 'container'
    path_container_images = File.join(path_container,'images')
    path_container_watermarks = File.join(path_container,'watermarks')
    path_container_watermarks_images = File.join(path_container_watermarks,'images')
    path_container_watermarks_text = File.join(path_container_watermarks,'text')
    empty_directory path_assets_images
    empty_directory path_assets_watermarks
    empty_directory path_container_images
    empty_directory path_container_watermarks_images
    empty_directory path_container_watermarks_text
  end
  def create_image_model
    template 'image_model.rb', File.join('app','models','image.rb')
  end
  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end
end    
