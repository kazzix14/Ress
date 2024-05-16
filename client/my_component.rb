# frozen_string_literal: true
# typed: true

# runs on client

def my_component
  my_json, set_my_json = Context.use_state(:my_json, '{}')

  error = begin
    JSON.parse(my_json)

    nil
  rescue JSON::ParserError => e
    "JSON is invalid: #{e.message}"
  end

  <<~SLIM
    .my-class
      .my-class-child
      .my-header
        .my-header-child
        = textarea :my_json, value: #{param.my_json}, on_change: -> (e) { set_my_json(e.target.value) }
        - unless error.nil?
          = error
  SLIM
end
