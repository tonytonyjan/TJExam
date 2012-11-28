# encoding: utf-8
require 'tmpdir'
require 'nokogiri'
require 'pp'

module TJExam
  module ImportTool
    def self.gen doc_filepath
      ary = nil
      Dir.mktmpdir{|dir|
        `unoconv -o #{dir} -f html #{doc_filepath}`
        unless $?.success?
          $stderr.puts $?
          break
        end
        html_file_name = File::join(dir, File::basename(doc_filepath).sub(/\.[^\.\/]+$|$/, '.html'))
        File::open(html_file_name){|f| 
          ary = TJExam::ImportTool::parse(f)
        }
      }
      ary
    end

    def self.parse file
      doc = Nokogiri::HTML(file)
      doc.css('script, link').each {|node| node.remove}
      # Convert image tag to Markdown format
      # doc.css('body img').each{|node| node.replace("![alt](#{node['src']})")}
      strip_tags!(doc)
      ary = separate(doc, "==SEPARATOR==")
      ary[1,ary.length].map{|string| process_question(string)}
    end

    def self.strip_tags! doc
      doc.css('body *').each{|node|
        if %w(img table tr td thead tbody).include?(node.name)
          # Keep image source
          node.attributes.each_value{|attr| attr.remove unless attr.name == "src"}
        else
          # Strip tag
          node.swap(node.children)
        end
      }
    end

    def self.separate doc, separator
      doc.css('body').inner_html.gsub(/(\n\t|\n|\t|\s)+/, '\1').split(separator)
    end

    # returns a hash for Question's parameters.
    def self.process_question string
      reg = /(?<key>【[^】]*】)(?<value>[^【]*)/m
      params = {}
      string.scan(reg){|m|
        case $~[:key].strip
        when "【科目】"
          params[:subject_list] = $~[:value].strip.gsub(/、/, ',')
        when "【題型】"
          params[:question_type_list] = $~[:value].strip.gsub(/、/, ',')
        when "【知識點】"
          params[:knowledge_point_list] = $~[:value].strip.gsub(/、/, ',')
        when "【章節來源】"
          params[:chapter_location_list] = $~[:value].strip.gsub(/、/, ',')
        when "【來源】"
          params[:location_list] = $~[:value].strip.gsub(/、/, ',')
        when "【來源出處】"
          params[:source_list] = $~[:value].strip.gsub(/、/, ',')
        when "【學習概念】"
          params[:concept_list] = $~[:value].strip.gsub(/、/, ',')
        end
      }
      params[:content] = string.gsub(reg, '').strip
      params
    end
  end
end

if $0 == __FILE__
  # p TJExam::ImportTool::gen "/home/tonytonyjan/codes/tmp/90math-1_format.doc"
  ary = TJExam::ImportTool::parse(File::open("/home/tonytonyjan/codes/tmp/90math-1_format_2/90math-1_format_2.html"))
  pp ary[0]
  #TJExam::ImportTool::process_question(ary[1])
end