module ApplicationHelper
  def logged_in?
    session[:current_user].present?
  end

  def render_flash
    ActiveSupport::SafeBuffer.new.tap do |output|
      [:notice, :success, :error].each do |kind|
        if flash[kind].present?
          output << content_tag(:div, class: "Alert Alert--#{kind}") do
            flash[kind]
          end
        end

        flash[kind] = nil
      end
    end
  end

  def pretty_print(json)
    content_tag :pre do
      content_tag :code do
        begin
          JSON.pretty_generate(JSON.parse(json))
        rescue StandardError
          json
        end
      end
    end
  end
end
