# Exception Handler
###
# You can add different settings using this block
# Use the docs at http://github.com/richpeck/exception_handler for info
###
ExceptionHandler.setup do |config|
  # DB -
  # Options = false / true
  config.db = false
  # Email -
  # Default = false / true
  #  config.email =
  # Social
  config.social = {
    twitter: 'http://twitter.com/frontlineutils',
    facebook: 'https://facebook.com/frontline.utilities',
    linkedin: 'https://linkedin.com/company/frontline-utilities',
    youtube: 'https://youtube.com/user/frontlineutils',
    fusion: 'http://frontlinefusion.com/frontlineutils'
  }

  # Response customizations
  # -----------------------
  # Use this to make changes to the response status code and headers.
  # For example, the following customization will remap 500 errors to
  # 503 errors and add a Retry-After header
  #
  # config.customize_response_by_status = {
  #   500 => {
  #     :status => 503,
  #     :headers => {
  #       "Retry-After" => 3600
  #     }
  #   }
  # }
  #
  # Callbacks
  # ---------
  # Specify a class and method to be called when an exception is caught
  # The method should take one parameter, which will be a hash with the
  # following keys:
  # :env => the environment object
  # :exception => the exception object
  # :details => exception name & details
  # :status  => HTTP status code (prior to any customizations)
  #
  # config.callback = {
  #   :class => MyLogAndAlertClass,
  #   :method => :log_and_alert
  # }
end
