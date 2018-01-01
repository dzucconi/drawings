module ApplicationHelper
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
