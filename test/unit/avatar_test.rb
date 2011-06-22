require File.dirname(__FILE__) + '/../test_helper'

class AvatarTest < ActiveSupport::TestCase

  setup do
    @a = Avatar.find(55)
  end

  test "find avatar" do
    assert_equal 55, @a.key
  end

  test "return mime filetype" do
    assert_match /^image\/[a-z]*$/, @a.filetype
  end

  # internals (hard to test 'generate')

  test "respond to public_interface" do
    assert @a.respond_to?(:generate)
    assert @a.respond_to?(:cleanup)
  end


end
