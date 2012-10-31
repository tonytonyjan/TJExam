class ExamPapersController < ApplicationController
  before_filter :simple_find, :only => [:show, :edit, :update, :destroy, :download]
  before_filter :simple_header
  before_filter :simple_resource
  
  def index
  end

  def show
  end

  def new
    @exam_paper.questions << Question.all.sample(10)
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def download
    tex_file = Tempfile.new('tjexam_', Rails.root.join('tmp'))
    begin
      tex_file.print @exam_paper.to_latex(params[:download_options])
    ensure
      tex_file.close
    end

    `xelatex #{tex_file.path} -interaction=nonstopmode -output-directory=#{Rails.root.join('tmp')}`
    if $? == 0
      send_file(Rails.root.join('tmp', "#{File.basename tex_file}.pdf"), :filename => "#{@exam_paper.name}.pdf", :type => "application/pdf", :disposition => 'inline')
      Dir.glob(Rails.root.join('tmp', "*.{aux,log}")).each{|f| File.unlink(f)}
    else
      flash[:alert] = "Failed!"
      Dir.glob("#{Rails.root.join('tmp', File.basename(tex_file) + '.*')}").each{|f| File.unlink(f)}
      redirect_to request.referer || @exam_paper
    end
    tex_file.unlink
  end
end