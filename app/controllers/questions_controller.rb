class QuestionsController < ApplicationController
  before_filter :simple_find, :only => [:show, :edit, :update, :destroy]
  before_filter :simple_header
  before_filter :simple_resource
  
  def index
  end

  def show
    @header = "#{Question.model_name.human} ##{@question.id}"
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def import_upload
    @header = "Import Questions"
  end

  def import_edit
    @header = "Edit Imported File"
    uploaded_io = params[:doc_file]
    ary = TJExam::gen params[:doc_file].tempfile.path
    @questions = ary.map{|item| Question.new content: item}
  end

  def import_save
  end
end
