require 'rubygems'
require 'test/unit'
require 'rails/generators'
require 'rails/generators/test_case'
class Plugin
  def self.root
    File.join(File.dirname(__FILE__),'..')
  end
end
