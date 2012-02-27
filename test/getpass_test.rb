require File.join(File.dirname(__FILE__), 'test_helper')

class GetpassTest < Test::Unit::TestCase
  include Getpass

  def test_return
    ungetch "\r"
    assert_equal '', getpass

    ungetch "\n"
    assert_equal '', getpass
  end

  def test_interupt
    assert_raise Interrupt do
      ungetch 3
      getpass
    end
  end

  def test_prompt
    ungetch "\n"
    output = get_stdout { getpass }
    assert_equal "\n", output

    ungetch "\n"
    output = get_stdout { getpass :prompt => 'Password: ' }
    assert_equal "Password: \n", output
  end
end
