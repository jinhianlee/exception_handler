module ExceptionHandler
  class ExceptionController < ActionController::Base

    #Response
    respond_to :html, :xml, :json

  	#Dependencies
  	before_action :status, :app_name

    #Layout
    layout :layout_status

    ####################
    #      Action      #
    ####################

  	#Show
    def show
      handled = run_exception_callback
      return if handled

      customize_response 

      respond_to do |format|
        format.any(:html, :json, :xml) { render status: @status }
      end
    end

    ####################
    #   Dependencies   #
    ####################

    protected

    #Info
    def status
      @exception  = env['action_dispatch.exception']
      @status     = ActionDispatch::ExceptionWrapper.new(env, @exception).status_code
      @response   = ActionDispatch::ExceptionWrapper.rescue_responses[@exception.class.name]
    end

    #Format
    def details
      @details ||= {}.tap do |h|
        I18n.with_options scope: [:exception, :show, @response], exception_name: @exception.class.name, exception_message: @exception.message do |i18n|
          h[:name]    = i18n.t "#{@exception.class.name.underscore}.title", default: i18n.t(:title, default: @exception.class.name)
          h[:message] = i18n.t "#{@exception.class.name.underscore}.description", default: i18n.t(:description, default: @exception.message)
        end
      end
    end
    helper_method :details

    # Response configuration
    # ----------------------
    # Allows additional configuration of the response
    # Right now this is status-specific, but could be extended to provide 
    # exception-specific customizations
    #
    # For example this could be used to turn a 500 Internal Server error into a temporary 503 error,
    # and add a Retry-After header, which is better for SEO if you expect errors to be fixed quickly
    # See: https://yoast.com/http-503-site-maintenance-seo/
    def customize_response
      cbs = ExceptionHandler.config.customize_response_by_status
      # could also add support for customizations by exception type

      if (cbs.kind_of? Hash) && (cbs[@status].kind_of? Hash)
        customize_response_with(cbs[@status])
      end
    end

    def customize_response_with(customizations)
      @status = customizations[:status] if customizations[:status] != nil
      response.headers.merge!(customizations[:headers]) if (customizations[:headers].kind_of? Hash)
      # could support more customizations here (e.g. layout, view, action, etc.)
    end


    # Run the callback function, if set
    def run_exception_callback
      handled = false
      ecb=ExceptionHandler.config.callback
      
      if (ecb.kind_of? Hash) && (ecb[:class] != nil) && (ecb[:class].kind_of? String)
        cb_response = ecb[:class].constantize.send(
          (ecb[:method] || :'exception_handler_callback'), {
            :env => env,
            :exception => @exception,
            :status => @status,
            :response => @response,
            :details => details
          }
        )
        handled = true if cb_response == true
      end

      return handled
    end

    ####################
    #      Layout      #
    ####################

    private

    #Layout
    def layout_status
      return ExceptionHandler.config.exception_layout || 'error' if @status.to_s != "404"
      ExceptionHandler.config.error_layout || 'application'
    end

    #App
    def app_name
      @app_name = Rails.application.class.parent_name
    end

  end
end
