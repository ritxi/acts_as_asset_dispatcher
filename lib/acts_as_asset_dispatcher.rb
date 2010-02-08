# ActsAsAssetDispatcher
require 'utils'
module ActsAsAssetDispatcher
  def store(id,contents)
    local_path = fileGetLocalPath(file_name).split('/')
    local_path.pop
    local_path = local_path.join('/')
    FileUtils.mkdir_p(local_path) unless Dir.exist?(local_path)
    return File.put_content(getLocalFilePath(file_name), contents)
  end
  def delete(id)
    begin
      path = getLocalFilePath(file_name);
      result = File.delete(path);
      parts = path.split('/')
      while(!parts.empty? && parts.pop)
        Dir.delete(parts.join('/'))
      end
    rescue SystemCallError
    ensure
      return result
    end
  end
  
  private
  def getExtenssion(path)
     splited_string = path.split('.')
     return splited_string.size == 2 ? ".#{splited_string[1]}" : ''
  end

  def getLocalFilePath(file_name)
      full_file_name = "#{file_name.md5}#{getExtenssion(file_name)}"
      return File.join(Rails.root,'assets',getHashedPath(file_name).dot_less_trim),full_file_name)
  end
  def getHashedPath(path)
    checksum = path.md5
    result = checksum.scan(/([a-z0-9]{3})/)
    if( result.size > 0 )
        return result.slice!(0,3).collect!{|x| "#{x}/" }.to_s
    end
  end
end