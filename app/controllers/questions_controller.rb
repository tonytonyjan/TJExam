class QuestionsController < ApplicationController
  load_and_authorize_resource
  before_filter :set_header, only: [:index, :show, :new, :edit]
  
  def index
    @questions = Question.all
  end

  def show
    @header = "#{Question.model_name.human} ##{@question.id}"
  end

  def new
  end

  def create
  end

  def edit
    @question.images.new
  end

  def update
    if @question.update_attributes params[:question]
      redirect_to @question
    else
      render "edit"
    end
  end

  def destroy
  end

  def import_upload
    @header = "Import Questions"
  end

  def import_edit
    @header = "Edit Imported File"
    uploaded_io = params[:doc_file]
    ary = TJExam::ImportTool::gen params[:doc_file].tempfile.path
    #ary = TJExam::ImportTool::parse(File::open("/home/tonytonyjan/codes/tmp/90math-1_format_3/90math-1_format_3.html"))
    @questions = ary.map{|hash| Question.new hash}
  end

  def import_save
    params[:questions].each{|q|q[:image_ids] = q[:image_ids].split(/[,\[\]]/)}
    @questions = Question.create params[:questions]
    @questions.select! &:invalid?
    unless @questions.present?
      flash[:notice] = t("tj.succeeded")
      redirect_to questions_path
    else
      @header = "Edit Imported File"
      render "import_edit"
    end
  end
end
