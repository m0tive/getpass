require 'rbconfig'

module Getpass
  if Config::CONFIG['host_os'] =~ /mswin|mingw/
    require 'Win32API'
    @@_getch = Win32API.new('crtdll', '_getch', [], 'L')
    @@_kbhit = Win32API.new('crtdll', '_kbhit', [], 'L')

    def self.pre_get; end

    def self.getch
      c = @@_getch.Call
    ensure
      # pop the next key off if it's one escaped
      @@_getch.Call if (c == 0 || c == 224) && @@_kbhit.Call == 1
    end

    def self.post_get; end
  else
    def self.pre_get
      @@_sttySettings = `stty --save`
      system 'stty raw -echo'
    end

    def self.getch
      STDIN.getc
    end

    def self.post_get
      system "stty #{@@_sttySettings}"
    end
  end

  def getpass(opts = {})
    $stdout.print opts[:prompt] unless opts[:prompt].nil?
    echo = (opts[:echo] || '*').to_s
    echoLen = echo.length
    clear = "#{"\b" * echoLen}#{' ' * echoLen}#{"\b" * echoLen}"

    Getpass.pre_get

    pass = ''
    loop do
      char = (id = Getpass.getch).chr

      raise Interrupt if id == 3 # Ctrl_c
      return pass if id == 13 || id == 10 # \r + \n

      # Only push visible characters
      if id > 31 && id != 127 && id != 224
        $stdout.print echo unless echo.empty?
        pass << char
      elsif id == 8 # backspace
        pass.sub! /.$/, ''
        $stdout.print clear unless echo.empty?
      end
    end
  ensure
    Getpass.post_get
    $stdout.print "\n" unless echo.empty?
  end

  module_function :getpass
end

if __FILE__ == $0
    puts 'Getpass.getpass ' << Getpass.getpass

    include Getpass

    puts 'A: ' << getpass(:prompt => 'Q: ')
    getpass :prompt => 'Password: '
    getpass :prompt => 'Ssssssh: ', :echo => ''
end
