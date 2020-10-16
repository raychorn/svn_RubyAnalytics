module ReportLinksHelper
  def link_to_add_heat_maps_association(*args, &block)
    if block_given?
      f            = args[0]
      association  = args[1]
      html_options = args[2] || {}
      link_to_add_association(capture(&block), f, association, html_options)
    else
      name         = args[0]
      f            = args[1]
      association  = args[2]
      html_options = args[3] || {}

      html_options[:class] = [html_options[:class], "add_fields"].compact.join(' ')
      html_options[:'data-association'] = association.to_s.singularize

      new_object = f.object.class.reflect_on_association(association).klass.new
      t = render_association(association, f, new_object)
=begin
      if t.to_s =~ /<textarea[^>]*>(.*?)<\/textarea>/
        match = $&
      else
        match = ""
      end
      match.gsub!('></textarea>',' onclick="javascript:alert(\'(+++)\');"></textarea>')
=end
      html_options[:'data-template'] = CGI.escapeHTML(t)

      link_to(name, '#', html_options )
    end
  end
end
