# typed: true

require '/bundle/setup'
require 'js'
require 'slim'
require 'json'

def upd(e = nil)
  puts e
  set_my_json(e)
  JS.global[:document].getElementById('my-textarea').focus();
end

def my_component
  use_state(:my_json, '{}')

  @error = begin
    JSON.parse(my_json.to_s)

    nil
  rescue JSON::ParserError => e
    "JSON is invalid: #{e.message}"
  end

  Slim::Template.new {
    <<~SLIM
      javascript:
      .my-class
        .my-class-child
        .my-header
          .my-header-child
          textarea#my-textarea[oninput='a = "upd(\\\\"" + String(this.value) + "\\\\")"; window.reval(a)']
            = my_json
        - if @error.nil?
          | JSON is valid.
        - else
          = @error
    SLIM
  }.render(self)
end

def use_state(name, initial_value)
  instance_variable_set("@#{name}", initial_value) unless instance_variable_defined?("@#{name}")

  define_method(name) do
    instance_variable_get("@#{name}")
  end

  define_method("set_#{name}") do |value|
    puts "set_#{name}"

    instance_variable_set("@#{name}", value)

    render
  end
end

def render_internal(context)
  JS.global[:document][:documentElement][:innerHTML] = Slim::Template.new { template }.render(context)
end

def validity
  (count % 3).zero?
end

def handle_click
  set_count count + 1
end

def handle_click2
  set_word JS.global.fetch('/random_word').await.text.await
end

def template
  <<~SLIM
    doctype html
    html
      head
        title Slim Template
      body
        h1[style="background-color: #{validity ? 'green' : 'red'}"] Hello from Slim! 🫰🏻
        p = word
        - if validity
          p 3の倍数
        - else
          p 3の倍数ではない
        button[onclick='window.reval("handle_click()");'] くっりくしてね
        button[onclick='window.reval("handle_click2()");'] くっりくしてね(API)
        p
          span くっりくした回数:
          span = count
          span 回
        == my_component
  SLIM
end

def render
  use_state(:count, 0)
  use_state(:word, '')

  render_internal(self)
end

render
