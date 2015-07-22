#! /usr/bin/env ruby
#
# shows agent version from agent support report

require 'rubygems/package'
require 'zlib'
require 'optparse'
require 'awesome_print' # gem install awesome_print

Options = Struct.new(:file)

class Parser
  def self.parse(options)
    args = Options.new(options)
    
    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: version.rb [options] <agent_support_report.tgz>"
      
      opts.on("-fFILE", "--file=FILE", "agent support report filename") do |value|
        args[:file] = value
      end
      
      opts.on_tail("-h", "--help", "Prints this help") {puts opts; exit}
      
      begin
        opts.parse!
      rescue OptionParser::ParseError => ex
        puts "Error: #{ex.message}"
        puts opts.help
        exit
      end  
    end
    
    opt_parser.parse!(options)   
    return args[:file]
  end
end

if ARGV.empty?
  Parser.parse %w[--help]
elsif  /^support/ =~ ARGV[0]
  agent_support_report = ARGV[0] 
else 
  agent_support_report = Parser.parse(ARGV)
end

class ReadFile
  attr_accessor :filename, :tarfile, :result, :hashtable
    
  def printfile
    tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open(@tarfile))
	tar_extract.rewind # The extract has to be rewinded after every iteration
    tar_extract.each do |entry|
  	  #puts entry.full_name
  	  #puts entry.directory?
  	  #puts entry.file?
  	  if entry.full_name.include? @filename
        @result = entry.read
        #puts @result
      end
	end
	tar_extract.close
  end
  
  def printresult(key, num1, num2=nil)
    # key is hashtable key, num1 is the line number of @filename, 
    # num2 is the array index of num1 which will be the value for key
    printfile
    ary = @result.to_str.lines
    str = ary[num1].split
    @hashtable = Hash.new
    if num2 == nil 
      str = ary[num1].chomp
      @hashtable[key] = str
    else
      str = ary[num1].split
      @hashtable[key] = str[num2]
    end
    #ap @hashtable, :indent => -20, :multiline => false, :color => {:keyword => :blue}
    @hashtable.each do |key, value|
      ap "#{key}".rjust(30, ' ') + " " + "#{value}".ljust(30, ' '), :color => {:string => :cyanish}
    end
  end
  
end

# print agent_version
agent = ReadFile.new
agent.filename = "agent_version"
agent.tarfile = agent_support_report
agent.printresult("agent version:", 0, 0)

# print agent_id.cfg file 
agent.filename = "agent_id.cfg"
agent.tarfile = agent_support_report
agent.printresult("agent_id:", 4, 1)
agent.printresult("org_id:", 6, 1)

# print agent_activation.cfg
agent.filename = "agent_activation.cfg"
agent.tarfile = agent_support_report
agent.printresult("masterconfig_server:", 5, 1)

# print agent hostname
agent.filename = "hostname"
agent.tarfile = agent_support_report
agent.printresult("hostname:", 0, 0)

# print agent uname
agent.filename = "uname"
agent.tarfile = agent_support_report
agent.printresult("uname:", 0)

# print agent lsb-release
agent.filename = "lsb-release"
agent.tarfile = agent_support_report
agent.printresult("distrib_id:", 0, 0)
agent.printresult("distrib_rel:", 1, 0)
agent.printresult("distrib_codename:", 2, 0)
agent.printresult("distrib_desc:", 3, 0)

# print config/processes
agent.filename = "config/processes"
agent.tarfile = agent_support_report
agent.printresult("illumio-control process0:", 1)
agent.printresult("illumio-control process1:", 2)
agent.printresult("illumio-control process2:", 3)
agent.printresult("illumio-control process3:", 4)
agent.printresult("illumio-control process4:", 5)
agent.printresult("illumio-control process5:", 6)
agent.printresult("illumio-control process6:", 7)

# print top data
agent.filename = "top"
agent.tarfile = agent_support_report
agent.printresult("top_data:", 0)
agent.printresult("top_data:", 2)
agent.printresult("top_data:", 3)
agent.printresult("top_data:", 4)
agent.printresult("top_data:", 6)
agent.printresult("top_data:", 7)
agent.printresult("top_data:", 8)
agent.printresult("top_data:", 9)
agent.printresult("top_data:", 10)
agent.printresult("top_data:", 11)
agent.printresult("top_data:", 12)


