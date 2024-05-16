# typed: true

require '/bundle/setup'
require 'js'
require 'slim'

def set_count(count)
  @count = count

  render
end

def count
  @count || 0
end

def template
  <<~SLIM
    doctype html
    html
      head
        title Slim Template
      body
        h1 Hello from Slim! 🫰🏻
        button[onclick='window.rubyVM.eval("set_count(count + 1)");'] くっりくしてね
        p
          span くっりくした回数:
          span = count
          span 回
  SLIM
end

def render
  html_output = Slim::Template.new { template }.render(self)
  JS.global[:document][:documentElement][:innerHTML] = html_output
end

render
