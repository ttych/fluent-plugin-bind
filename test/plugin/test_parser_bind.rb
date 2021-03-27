require "helper"
require "fluent/plugin/parser_bind.rb"

class BindParserTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  test "failure" do
    flunk
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Parser.new(Fluent::Plugin::BindParser).configure(conf)
  end
end
