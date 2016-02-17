require 'test/unit'
require 'stringio'
require 'getpass'


class GetpassTest < Test::Unit::TestCase
  def ascii(char)
    char.is_a?(Fixnum) ? char : char[0].ord
  end

  if RbConfig::CONFIG['host_os'] =~ /mswin|mingw/
    require "Win32API"
    @@_ungetch = Win32API.new('crtdll', '_ungetch', [], 'L')

    def ungetch(char)
      @@_ungetch.call ascii(char)
    end

  else
    def ungetch(char)
      STDIN.ungetc ascii(char)
    end
  end

  def get_stdout
    oldStdout, $stdout = $stdout, StringIO.new

    yield

    return $stdout.string
  ensure
    $stdout = oldStdout
  end
end
