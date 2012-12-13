# encoding: utf-8
require 'tmpdir'
require 'nokogiri'
require 'pp'

module TJExam
  module ImportTool
    def self.gen doc_filepath
      ary = nil
      Dir.mktmpdir{|dir|
        @tmp_dir = dir
        `unoconv -o #{@tmp_dir} -f html #{doc_filepath}`
        unless $?.success?
          $stderr.puts $?
          break
        end
        html_file_name = File::join(@tmp_dir, File::basename(doc_filepath).sub(/\.[^\.\/]+$|$/, '.html'))
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
      @images = {}
      doc.css('body *').each{|node|
        if %w(img table tr td thead tbody u).include?(node.name)
          # Keep image source
          node.attributes.each_value{|attr|
            if attr.name == "src"
              if @tmp_dir
                img = Image.create file: File::open(File::join(@tmp_dir, attr.value))
                attr.value = img.file_url
                @images[attr.value] = img
              end
            elsif %w(width height).include?(attr.name)
            else
              attr.remove
            end
          }
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
    # note that "【答案】" should appear after "【答案選項】"
    def self.process_question string
      reg = /(?<key>【[^】]*】)(?<value>[^【]*)/m
      params = {}
      string.scan(reg){|m|
        group_key, group_value = $~[:key].strip, $~[:value].strip
        puts group_key, "-----------------------------------"
        case group_key
        when "【答案選項】"
          options_reg = /(?<key>[\(（][A-Z][\)）])(?<value>[^\(]*)/m
          params[:options_attributes] = []
          group_value.scan(options_reg){|mm|
            params[:options_attributes] << {key: $~[:key].strip, content: $~[:value].strip}
          }
        when /【[^【]*答案】/
          if params[:options_attributes]
            group_value.scan(/[\(（][A-Z][\)）]/).each{|m|
              params[:options_attributes].each{|item|
                item[:is_answer] = true if item[:key].strip == m.strip
              }
            }
          end
        when "【科目】"
          params[:subject_list] = group_value.gsub(/、/, ',')
        when "【題型】"
          params[:question_type_list] = group_value.gsub(/、/, ',')
        when "【知識點】"
          params[:knowledge_point_list] = group_value.gsub(/、/, ',')
        when "【章節來源】"
          params[:chapter_location_list] = group_value.gsub(/、/, ',')
        when "【來源】"
          params[:location_list] = group_value.gsub(/、/, ',')
        when "【來源出處】"
          params[:source_list] = group_value.gsub(/、/, ',')
        when "【學習概念】"
          params[:concept_list] = group_value.gsub(/、/, ',')
        end
      }
      params[:content] = string.gsub(reg, '').strip
      params[:image_ids] = []
      params[:content].scan(/<img[^>]*src="(?<src>[^"]*)"[^>]*>/){|m|
        params[:image_ids] << @images[$~[:src]].id if @images[$~[:src]]
      }
      params[:options_attributes].each{|item| item.delete :key} if params[:options_attributes]
      params
    end
  end
end

if $0 == __FILE__
  #ary = TJExam::ImportTool::gen "/home/tonytonyjan/codes/tmp/90math-1_format_3.doc"
  ary = TJExam::ImportTool::parse(File::open("/home/tonytonyjan/codes/tmp/90math-1_format_3/90math-1_format_3.html"))
  pp ary
end