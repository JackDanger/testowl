module Testowl
  module Growl

    def self.grr(title, message, status, files, suffix)
      project = File.expand_path(".").split("/").last
      growlnotify = `which growlnotify`.chomp
      options = []
      options << "-n Watchr"
      options << "--message '#{message.gsub("'", "`")}\n\n#{files.map{|file| file.sub(/^spec\/[^\/]*\//, '').sub(/_test.rb$/, '')}.join("\n")}\n#{suffix}'"
      options << "--sticky" if status == :error
      options << "--image '#{image_path(status)}'"
      options << "--identifier #{Digest::MD5.hexdigest files.join}" # (used for coalescing)
      title = "RSpec #{title} (#{project})"
      system %(#{growlnotify} #{options.join(' ')} '#{title}' &)
    end

    def self.image_path(name)
      File.dirname(__FILE__) + "/../../images/#{name}.png"
    end

  end
end