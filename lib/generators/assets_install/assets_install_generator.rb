require 'rails/generators'

class AssetsInstallGenerator < Rails::Generators::Base
  
  def create_base_folders

    path_assets = 'Assets'
    path_assets_images = File.join(path_assets,'Images')
    path_assets_watermarks = File.join(path_assets,'Watermarks')
    path_container = 'Container'
    path_container_images = File.join(path_container,'Images')
    path_container_watermarks = File.join(path_container,'Watermarks')
    path_container_watermarks_images = File.join(path_container_watermarks,'Images')
    path_container_watermarks_text = File.join(path_container_watermarks,'Text')
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
