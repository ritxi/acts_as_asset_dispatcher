require "digest"
require 'net/http'
require 'FileUtils'
require 'base64'
require 'socket'
require 'time'
require 'tmpdir'

class Object
  def array?
    false
  end
  def hash?
    false
  end
  def string?
    false
  end
  def symbol?
    false
  end
  def class_exists? kls
    begin
      kls = Object.const_get kls.to_s.camelize.to_sym
      kls.kind_of? Class
    rescue Exception
      false
    end
  end
  def module_exists? kls
    begin
      kls = Object.const_get kls.to_s.camelize.to_sym
      kls.kind_of? Module
    rescue Exception
      false
    end
  end
  def is_scalar?
    [Fixnum, Integer, Float, String, FalseClass, TrueClass].include?(self.class)
  end
  def can_be_empty?
    respond_to?(:empty?)
  end
end 
class Symbol
  def symbol?
    true
  end
  def stringtify
    a = "\:#{self.to_s}"
    return a
  end
  def is_numeric?
    self.to_s.is_numeric?
  end
end
class Array
  def array?
    true
  end
end
class String
  def string?
    true
  end
  def first(limit = 1)
    if limit == 0
      ''
    elsif limit >= size
      self
    else
      to(limit - 1)
    end
  end
  def to(position)
    self[0..position]
  end
  def camelize(first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      self.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
    else
      self.first + self.camelize[1..-1]
    end
  end
  def underscore
    self.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end
  def dot_less_trim
    if(result = /^\.(.*)\.$/.match(self) || result = /^\.(.*)$/.match(self) || result = /^(.*)\.$/.match(self))
      return result[1]
    else
      return self
    end
  end
  def simple_quotation_less_trim
    if(result = /^\'(.*)\'$/.match(self) || result = /^\'(.*)$/.match(self) || result = /^(.*)\'$/.match(self))
      return result[1]
    else
      return self
    end
  end
  def md5
    Digest::MD5.hexdigest self
  end
  def enc64
    Base64.encode64(self)
  end
  def dec64
    Base64.decode64(self)
  end
  def is_numeric?
    Float self rescue return false
    return true
  end
  def is_integer?
    Integer self rescue return false
    return true
  end
  def keyfy
    self.slice(0,1) == ':' ? self.slice(1..-1).to_sym : self
  end
  def dec2hex
     number = Integer(self);
     hex_digit = "0123456789ABCDEF"
     ret_hex = '';
     while(number != 0)
        ret_hex = String(hex_digit.slice(number % 16,1)) + ret_hex;
        number = number / 16;
     end
     return ret_hex; ## Returning HEX
  end
  def casecompare(string)
    self.downcase == string.downcase
  end
end
class Integer
  def is_numeric?
    true
  end
end
class Float
  def is_numeric?
    true
  end
end
class Hash
  def isset? key
    !self[key].nil? ?  (self[key].can_be_empty? ? !self[key].empty? : self[key].symbol? ? true : self[key] == true) : false
  end
  def hash?
    true
  end
  def keyfy!(options = {})
    default = {:recursive => false, 
               :symbolize_strings => false}
    
    options = default.merge(options)
    t = self.dup
    self.clear
    t.each_pair{|k, v| 
      options[:recursive] && v.hash? && v.keyfy!(options)
      options[:symbolize_strings] && v.string? && v = v.keyfy
      self[k.to_sym] = v
    }
    self
  end
  def unkeyfy!(options = {})
    default = {:recursive => false, 
               :stringtify_symbol => false}
    options = default.merge(options)
    t = self.dup
    self.clear
    t.each_pair{|k, value| 
      options[:recursive] && value.hash? && value.unkeyfy!(options)
      options[:stringtify_symbol] && value.symbol? && value = value.stringtify

      self[k.to_s] = value
    }
    self
  end
  def flip!
    result = self.dup
    self.clear
    self.merge!(result.flip)
  end
  def flip
    return self.class[*self.to_a.flatten.reverse]
  end
end
class File
  def self.md5(file)
    digest = Digest::MD5.new
    self.open(file, "r") do |f|
      digest.update f.read(8192) until f.eof
    end
    return digest.to_s
  end
  def self.get_content(file)
    File.file?(file) ? File.open(file).read : Net::HTTP.get_response(URI.parse(file)).body
  end
  def self.put_content(file, content)
    newFile = File.open(file, "w")
    newFile.write(content)
    newFile.close
  end
  def self.tmpnam opts = {}, &b
    dir = opts['dir'] || opts[:dir] || Dir.tmpdir
    seed = opts['seed'] || opts[:seed] || $0
    path =
    "%s_%s_%s_%s_%d" % [
      Socket.gethostname,
      seed,
      Process.pid,
      Time.now.iso8601(2),
      rand(101010)
    ]
    dirname, basename = split path
    tn = join(dir, dirname, basename.gsub(%r/[^0-9a-zA-Z]/,'_')).gsub(%r/\s+/, '_')
    tn = expand_path tn
    b ? open(tn,'w+', &b) : tn
  end
end
class Dir
  unless self.respond_to?(:exist?)
    def self.exist?(path)
      File.directory?(path)
    end
    class << self
      alias_method :exists?, :exist?
    end
  end
end
class Utils
  def self.copy(src,dest,options={})
    if(File.file? src)
      dest_dir = dest.split('/')
      src.split('/').pop == dest.split('/').pop ? dest_dir.pop : ''
      unless(File.directory? dest_dir.join('/'))
        FileUtils.mkdir_p dest_dir.join('/')
      end
      FileUtils.cp src, dest
      return true
    else
      return false
    end
    #Create folders first and copy file then
  end
end