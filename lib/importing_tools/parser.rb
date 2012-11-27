require 'nokogiri'
require 'pp'

module TJExam
  # returns an array of content
  def self.parse file
    doc = Nokogiri::HTML(file)
    doc.css('script, link').each {|node| node.remove}
    # Convert image tag to Markdown format
    # doc.css('body img').each{|node| node.replace("![alt](#{node['src']})")}
    doc.css('body *').each{|node|
      unless %w(img table tr td thead tbody).include?(node.name)
        # Strip tag
        node.swap(node.children)
      else
        # Keep image source
        node.attributes.each_value{|attr| attr.remove unless attr.name == "src"}
      end
    }
    separator = "==@@T_BEGIN@@=="
    doc.css('body').inner_html.gsub(/(\n\t|\n|\t|\s)+/, '\1').split(separator)
  end
end

if $0 == __FILE__
  puts TJExam::parse(File::open("/home/tonytonyjan/codes/tmp/90math-1_format/90math-1_format.html"))
end