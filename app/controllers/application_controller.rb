class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    nil
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

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_url, :alert => exception.message
  end
end
