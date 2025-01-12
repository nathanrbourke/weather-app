module ApplicationHelper
  def log_debug(error)
    Rails.logger.debug("#{error.class.name}, Message: #{error.message}")
  end
end
