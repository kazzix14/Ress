# typed: true

require '/bundle/setup'
require 'js'
require 'slim'

def write
  @during_write = true
  yield
  @during_write = false

  render
end

def use_state(name, initial_value)
  instance_variable_set("@#{name}", initial_value) unless instance_variable_defined?("@#{name}")

  define_method(name) do
    instance_variable_get("@#{name}")
  end

  define_method("set_#{name}") do |value|
    raise 'must be inside dirty' unless @during_write

    instance_variable_set("@#{name}", value)
  end
end

def render_internal(context)
  JS.global[:document][:documentElement][:innerHTML] = Slim::Template.new { template }.render(context)
end

def validity
  (count % 3).zero?
end

def handle_click
  write do
    set_count count + 1
  end
end

def handle_click2
  write do
    set_word JS.global.fetch('/random_word').await.text.await
  end
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
  SLIM
end

def render
  use_state(:count, 0)
  use_state(:word, '')

  render_internal(self)
end

render
