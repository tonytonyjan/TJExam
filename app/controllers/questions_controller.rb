class QuestionsController < ApplicationController
  before_filter :find, :only=>[:edit, :update, :show, :destroy]
  
  def index
    @header = "Browse Questions"
    @questions = Question.all
  end

  def show
    @header = "Question ##{@question.id}"
  end

  def new
    @header = "New Question"
    @question = Question.new
  end

  def create
    @question = Question.new params[:question]
    if @question.save
      render "new"
    else
      flash[:notice] = "Succeed!"
      redirect_to @question
    end
  end

  def edit
    @header = "Edit Question ##{@question.id}"
  end

  def update
    if @question.update_attributes params[:question]
      render "edit"
    else
      flash[:notice] = "Succeed!"
      redirect_to @question
    end
  end

  def destroy
    @question.destroy
    flash[:notice] = "Sudcceed!"
  end

  def find
    unless @question = Question.find_by_id(params[:id])
      flash[:alert] = "Not Found!"
      redirect_to request.referer || questions_path
    end
  end
end
