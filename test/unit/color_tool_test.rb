require File.dirname(__FILE__) + '/../test_helper'

class ColorToolTest < ActiveSupport::TestCase
  setup do
    @body_color='#112233'
    @ct = ColorTool.new(@body_color)
  end

  test "generate random number within a min and max" do
    # TODO: mock Kernel.rand to return 0
    assert @ct.rand_float(4,10) >= 4
    # TODO: mock Kernel.rand to return 0.9999999
    assert @ct.rand_float(4,10) <= 10
  end

  test "generate a random color" do
    assert_match /^#[0-9A-Fa-f]{6}$/, @ct.random
    assert_not_equal @ct.random, @ct.random
    assert_not_equal @body_color, @ct.random
  end

  test "return body color when asking for a body color" do
    ['#000000','#660066', '#999999'].each do |color|
      assert_equal color,  ColorTool.new(color).color(:body)
    end
  end

  test "return a non body color when asking for another color" do
    #TODO: should call @ct.random
    assert_not_equal @body_color, @ct.color
    assert_not_equal @body_color, @ct.color(:random)
    assert_not_equal @body_color, @ct.color(:arm)
  end

  test "return a color if a color is passed in" do
    color = '#123456'
    assert_equal color, @ct.color(color)
  end
end