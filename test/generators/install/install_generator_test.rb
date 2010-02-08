require 'test_helper'
require 'generators/assets_install/assets_install_generator'

class AssetsInstallGeneratorTest < Test::Unit::TestCase
  def setup
    @destination = File.join(Plugin.root,'tmp','test_app')
    AssetsInstallGenerator.start('',:destination_root => @destination)
  end
  def teardown
    FileUtils.rm_rf(@destination)
  end
  def test_install_base_folders
    path_assets = File.join(@destination,'assets')
    path_assets_images = File.join(path_assets,'images')
    path_assets_watermarks = File.join(path_assets,'Watermarks')
    path_container = File.join(@destination,'container')
    path_container_images = File.join(path_container,'images')
    path_container_watermarks = File.join(path_container,'watermarks')
    path_container_watermarks_images = File.join(path_container_watermarks,'images')
    path_container_watermarks_text = File.join(path_container_watermarks,'text')
    assert File.exists?(path_assets_images)
    assert File.exists?(path_assets_watermarks)
    assert File.exists?(path_container_images)
    assert File.exists?(path_container_watermarks_images)
    assert File.exists?(path_container_watermarks_text)
  end
  def test_install_image_model
    assert File.exists?(File.join(@destination,'app','models','image.rb'))
  end
end