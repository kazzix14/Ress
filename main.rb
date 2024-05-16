# typed: false

require 'sinatra'

before do
  content_type 'application/wasm' if request.path_info.end_with?('.wasm')
end

get '/random_word' do
  %w[いいね いいねいいね いいねいいねいいね].sample
end

get '/ruby.wasm' do
  response.headers['X-Content-Type-Options'] = ''
  content_type 'application/wasm'
  # content_type :wasm
  send_file File.open('client/ruby.wasm')
end

get '/' do
  browser_code = File.open('client/browser.rb').read
  <<~HTML
    <html>
      <script type="module" data-eval="async">
        import { DefaultRubyVM } from "https://cdn.jsdelivr.net/npm/@ruby/wasm-wasi@2.6.0/dist/browser/+esm";
        const response = await fetch("ruby.wasm");
        const module = await WebAssembly.compileStreaming(response);
        const { vm } = await DefaultRubyVM(module);

        window.reval = (code) => {
          vm.evalAsync(code);
        };

        vm.evalAsync(`#{browser_code}`);
      </script>
    </html>
  HTML
end
