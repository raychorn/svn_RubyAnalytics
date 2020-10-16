module AnalyticsRenderer
  # the reason we have this here is because a different render method is called for
  # the view (in a helper class) versus the controller
  def render_report(object, options = {}, locals = {}, &block)
    if object.present?
      path_prefix = object.class.to_s.underscore.pluralize
    else
      path_prefix = 'reports'
    end
    if options[:template]
      options[:template] = File.join(path_prefix, options[:template])
    end
    if options[:partial]
      options[:partial] = File.join(path_prefix, options[:partial])
    end
    render(options, locals, &block)

  end
end