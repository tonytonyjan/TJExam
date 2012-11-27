require 'tmpdir'
require File.expand_path("../parser", __FILE__)

module TJExam

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
        ary = TJExam::parse(f)
      }
    }
    ary
  end
end

if $0 == __FILE__
  p TJExam::gen "/home/tonytonyjan/codes/tmp/90math-1_format.doc"
end