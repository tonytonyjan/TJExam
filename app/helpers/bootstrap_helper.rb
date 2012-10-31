module BootstrapHelper
  def record_message object
    error_messages_for object, :class=>"alert alert-block alert-error", :header_tag=>"h4"
  end

  def notice_message
    flash_messages = []
    flash.each do |type, message|
      type = case type
      when :notice then :success
      when :alert then :error
      end
      content = content_tag :div, :class => "alert fade in alert-#{type}" do
        button_tag("x", :class => "close", "data-dismiss" => "alert") + message
      end
      flash_messages << content if message.present?
    end
    flash_messages.join("\n").html_safe
  end

  # title, size = 1
  #
  # size = 1, &block
  def page_header *args, &block
    if block_given?
      size = (1..6) === args.first ? args.first : 1
      content_tag :div, :class => "page-header" do
        content_tag "h#{size}" do
          capture(&block)
        end
      end
    else
      title = args.first
      size = (1..6) === args.second ? args.second : 1
      content_tag :div, content_tag("h#{size}", title), :class => "page-header"
    end
  end

  # Just like +link_to+, but wrap with li tag and set +class="active"+
  # to corresponding page.
  def nav_li *args, &block
    options = (block_given? ? args.first : args.second) || {}
    url = url_for(options)
    active = "active" if url == request.path || url == request.url
    content_tag :li, :class => active do
      link_to *args, &block
    end
  end
end