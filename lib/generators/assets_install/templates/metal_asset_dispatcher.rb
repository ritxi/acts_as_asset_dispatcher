# Allow the metal piece to run in isolation
require File.expand_path('../../../config/environment',  __FILE__) unless defined?(Rails)

class AssetDispatcher
  def self.call(env)
    url = env["PATH_INFO"].match(/^\/dispatcher\/([a-z]{2})\-(.*)\.([a-z]{3,4})/)
    unless url.nil?
      key       = url[1]
      hash      = url[2]
      extension = url[3]
      [200, {"Content-Type" => "text/html"}, "#{key} #{hash} #{extension}"]
    else
      [404, {"Content-Type" => "text/html", "X-Cascade" => "pass"}, ["Not Found"]]
    end
  end
end