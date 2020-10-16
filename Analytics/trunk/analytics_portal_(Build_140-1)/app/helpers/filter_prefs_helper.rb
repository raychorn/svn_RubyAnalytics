module FilterPrefsHelper
  def link_to_remove(*args)
    name         = args[0]
    f            = args[1]
    html_options = args[2] || {}
    # Usage:   <%= link_to_remove "Remove KPI", f %>
    begin
      if f.object.kind_of?(FilterPref)
        kname = f.object.as_json().keys[0]
        if f.object.id.nil?
          #js = "alert('WARNING: Cannot delete this KPI (filter_param_id=#{f.object.attributes['filter_param_id']})... This part of the database has become corrupt.');"
          js = "_ajax_request('/filter_params/#{f.object.attributes['filter_param_id']}', '', function(d) { alert(window.location.href); }, 'json', 'DELETE');"
        else
          js = "_ajax_request('/#{kname}s/#{f.object.id}', '', function(d) { alert(window.location.href); }, 'json', 'DELETE');"
        end
        button_to_function name, js, :class => "ok"
      end
    rescue
    end
  end
end
