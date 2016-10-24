require 'logger_helper'

class LogFilesController < ApplicationController
	include LoggerHelper
	def list_logs
		@log_files = log_files
	end

	def show
		render file: LoggerHelper.full_log_file_path(params[:logfile]), layout: false, content_type: 'text/plain'
	end
end