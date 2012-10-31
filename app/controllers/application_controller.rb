class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def simple_save record
    if record.save
      flash[:notice] = "Succeed!"
      redirect_to record
    else
      render "new"
    end
  end

  # filters
  def simple_find
    record_class = controller_name.classify.constantize
    unless instance_variable_set("@#{controller_name.singularize}".to_sym, record_class.find_by_id(params[:id]))
      flash[:alert] = "Not found!"
      url_symbol = ("#{controller_name}_path").to_sym
      redirect_to request.referer || send(url_symbol)
    end
  end

  def simple_header
    record_class = controller_name.classify.constantize
    @header = case action_name
    when "index" then record_class.model_name.human
    when "show" then
      record = instance_variable_get("@#{controller_name.singularize}".to_sym)
      record.name if record.respond_to? :name
    when "new" then t("helpers.submit.create", :model => record_class.model_name.human)
    when "edit" then t("helpers.submit.update", :model => record_class.model_name.human)
    end
  end

  def simple_resource
    record_class = controller_name.classify.constantize
    singular_string = controller_name.singularize
    plural_string = controller_name
    case action_name
    when "index"
      instance_variable_set('@' + plural_string, record_class.all)
    when "show"
    when "new"
      instance_variable_set('@' + singular_string, record_class.new)
    when "create"
      simple_save instance_variable_set('@' + singular_string, record_class.new(params[singular_string]))
    when "edit"
    when "update"
      record = instance_variable_get('@' + singular_string)
      if record.update_attributes params[singular_string]
        flash[:notice] = "Succeed!"
        redirect_to record
      else
        render "edit"
      end
    when "destroy"
      record = instance_variable_get('@' + singular_string)
      record.destroy
      flash[:notice] = "Sudcceed!"
      url_symbol = ("#{controller_name}_path").to_sym
      redirect_to send(url_symbol)
    end
  end
end
