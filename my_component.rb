# typed: false
def my_component
  name, set_name = set_state(:name, 'John')

  render do
    h1 "Hello, #{name}!"

    input value: name, on_change: ->(e) { set_name(e.target.value) }
  end
end

my_component
