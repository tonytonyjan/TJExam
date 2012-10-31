class ExamPapersController < ApplicationController
  def new
    @header = "New Exam Paper"
    @exam_paper = ExamPaper.new
    @exam_paper.questions << Question.all.sample(10)
  end

  def create
    @exam_paper = ExamPaper.new params[:exam_paper]
    tex_file = Tempfile.new('prefix', Rails.root.join('tmp'))
    begin
      tex_file.print @exam_paper.to_latex
    ensure
      tex_file.close
    end
    `xelatex #{tex_file.path} -interaction=nonstopmode -output-directory=#{Rails.root.join('tmp')}`
    send_file(Rails.root.join('tmp', "#{File.basename tex_file}.pdf"), :filename => "exam.pdf", :type => "application/pdf")
    tex_file.unlink
    # Dir.glob("#{Rails.root.join('tmp', File.basename(tex_file) + '.*')}").each { |f| File.unlink(f) }
  end
end
