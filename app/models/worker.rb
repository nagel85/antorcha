
require 'daemons'
require 'rbconfig'

class Worker
  WINDOZE = Config::CONFIG['host_os'] =~ /mswin|mingw/

  def self.all
    group = Daemons::ApplicationGroup.new('delayed_job')
    group.find_applications(File.join(Rails.root,'tmp','pids')).map do |app|
      Worker.new app
    end
  end

  def self.start
    if WINDOZE
      f = IO.popen "SET RAILS_ENV=#{Rails.env} & \"#{File.join(Rails.root,'start_engine.bat')}\""
    else
      f = IO.popen "env RAILS_ENV=#{Rails.env} #{File.join(Rails.root,'script','delayed_job')} start"
    end
    
    f.readlines
    f.close
  end

  def pid
    @application.pid.pid
  end
  
  def to_param
    pid.to_s
  end

  def running?
    @application.running?
  end
  
  def stop
    @application.stop
  end

  def initialize app
    @application = app
  end
  
  def self.human_name(options = {})
    I18n.t("activerecord.models.worker", options)
  end
  
end
