class Logger::SimpleFormatter
  def call(severity, time, progname, msg)
    "#{severity_color severity} #{String === msg ? msg : msg.inspect}\n"
  end

  private

  def severity_color(severity)
    case severity
    when 'DEBUG'
      format('0;36m', :DEBUG)
    when 'INFO'
      format('0;33m', :INFO)
    when 'WARN'
      format('1;33m', :WARNING)
    when 'ERROR'
      format('41;1;37m', :ERROR)
    when 'FATAL'
      format('41;1;37m', :FATAL)
    else
      "[#{severity}]"
    end
  end

  def format(color, label)
    "\033[#{color}[#{label}]\033[0m [#{Time.current}]"
  end
end
