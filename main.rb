# typed: false

require 'sinatra'

get '/' do
  <<~HTML
    <html>
      <script src="https://cdn.jsdelivr.net/npm/@ruby/3.3-wasm-wasi@2.6.0/dist/browser.script.iife.min.js"></script>
      <script type="text/ruby">
        #{File.open('browser.rb').read}
      </script>
    </html>
  HTML
end
