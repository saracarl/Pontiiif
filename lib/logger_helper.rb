module LoggerHelper
  require 'date'
  LOG_DIR = File.join(Rails.root, "tmp", "logs")
  unless Dir.exist?(LOG_DIR) then Dir.mkdir(LOG_DIR) end
  def self.log_error(e, manifest) 
    # get domain of manifest
    host = URI.parse(manifest).host.downcase
    # open log file per domain
    File.open(full_log_file_path(host), "a") do |log|
      log.puts Time.now.strftime("%d/%m/%Y %H:%M") + " Can't open " + manifest + " Error: #{e}"
    end
  end

  def log_files
  	Dir.glob(File.join(LOG_DIR, "*.log"))
  end

  def self.full_log_file_path(host)
  	if host.index('.')
	  	host = 	host.gsub!('.', '_')
	end
  	File.join(LOG_DIR, (host + ".log"))
  end

end