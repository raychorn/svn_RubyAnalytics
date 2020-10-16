/**
 * Unobtrusive scripting adapter for jQuery
 *
 * Requires jQuery 1.4.3 or later.
 * https://github.com/rails/jquery-ujs
 */

(function($) {
	// Make sure that every Ajax request sends the CSRF token
	function CSRFProtection(xhr) {
		var token = $('meta[name="csrf-token"]').attr('content');
		if (token) xhr.setRequestHeader('X-CSRF-Token', token);
	}
	if ('ajaxPrefilter' in $) $.ajaxPrefilter(function(options, originalOptions, xhr){ CSRFProtection(xhr) });
	else $(document).ajaxSend(function(e, xhr){ CSRFProtection(xhr) });

	// Triggers an event on an element and returns the event result
	function fire(obj, name, data) {
		var event = $.Event(name);
		obj.trigger(event, data);
		return event.result !== false;
	}

	// Submits "remote" forms and links with ajax
	function handleRemote(element) {
		var method, url, data,
			dataType = element.data('type') || ($.ajaxSettings && $.ajaxSettings.dataType);

	if (fire(element, 'ajax:before')) {
		if (element.is('form')) {
			method = element.attr('method');
			url = element.attr('action');
			data = element.serializeArray();
			// memoized value from clicked submit button
			var button = element.data('ujs:submit-button');
			if (button) {
				data.push(button);
				element.data('ujs:submit-button', null);
			}
		} else {
			method = element.data('method');
			url = element.attr('href');
			data = null;
		}
			$.ajax({
				url: url, type: method || 'GET', data: data, dataType: dataType,
				// stopping the "ajax:beforeSend" event will cancel the ajax request
				beforeSend: function(xhr, settings) {
					if (settings.dataType === undefined) {
						xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script);
					}
					return fire(element, 'ajax:beforeSend', [xhr, settings]);
				},
				success: function(data, status, xhr) {
					element.trigger('ajax:success', [data, status, xhr]);
				},
				complete: function(xhr, status) {
					element.trigger('ajax:complete', [xhr, status]);
				},
				error: function(xhr, status, error) {
					element.trigger('ajax:error', [xhr, status, error]);
				}
			});
		}
	}

	// Handles "data-method" on links such as:
	// <a href="/users/5" data-method="delete" rel="nofollow" data-confirm="Are you sure?">Delete</a>
	function handleMethod(link) {
		var href = link.attr('href'),
			method = link.data('method'),
			csrf_token = $('meta[name=csrf-token]').attr('content'),
			csrf_param = $('meta[name=csrf-param]').attr('content'),
			form = $('<form method="post" action="' + href + '"></form>'),
			metadata_input = '<input name="_method" value="' + method + '" type="hidden" />';

		if (csrf_param !== undefined && csrf_token !== undefined) {
			metadata_input += '<input name="' + csrf_param + '" value="' + csrf_token + '" type="hidden" />';
		}

		form.hide().append(metadata_input).appendTo('body');
		form.submit();
	}

	function disableFormElements(form) {
		form.find('input[data-disable-with]').each(function() {
			var input = $(this);
			input.data('ujs:enable-with', input.val())
				.val(input.data('disable-with'))
				.attr('disabled', 'disabled');
		});
	}

	function enableFormElements(form) {
		form.find('input[data-disable-with]').each(function() {
			var input = $(this);
			input.val(input.data('ujs:enable-with')).removeAttr('disabled');
		});
	}

	function allowAction(element) {
		var message = element.data('confirm');
		return !message || (fire(element, 'confirm') && confirm(message));
	}

	function requiredValuesMissing(form) {
		var missing = false;
		form.find('input[name][required]').each(function() {
			if (!$(this).val()) missing = true;
		});
		return missing;
	}

	$('a[data-confirm], a[data-method], a[data-remote]').live('click.rails', function(e) {
		var link = $(this);
		if (!allowAction(link)) return false;

		if (link.data('remote') != undefined) {
			handleRemote(link);
			return false;
		} else if (link.data('method')) {
			handleMethod(link);
			return false;
		}
	});

	$('form').live('submit.rails', function(e) {
		var form = $(this), remote = form.data('remote') != undefined;
		if (!allowAction(form)) return false;

		// skip other logic when required values are missing
		if (requiredValuesMissing(form)) return !remote;

		if (remote) {
			handleRemote(form);
			return false;
		} else {
			// slight timeout so that the submit button gets properly serialized
			setTimeout(function(){ disableFormElements(form) }, 13);
		}
	});

	$('form input[type=submit], form button[type=submit], form button:not([type])').live('click.rails', function() {
		var button = $(this);
		if (!allowAction(button)) return false;
		// register the pressed submit button
		var name = button.attr('name'), data = name ? {name:name, value:button.val()} : null;
		button.closest('form').data('ujs:submit-button', data);
	});

	$('form').live('ajax:beforeSend.rails', function(event) {
		if (this == event.target) disableFormElements($(this));
	});

	$('form').live('ajax:complete.rails', function(event) {
		if (this == event.target) enableFormElements($(this));
	});
})( jQuery );

$(document).ready(function() {
    $('.spacer').each(function(i, el) {
        el.style.height = '25px';
    });
    $('.links').each(function(i, el) {
        //el.className = 'mine-button';
    });
});

/**
 * Created by JetBrains RubyMine.
 * User: rhorn
 * Date: 9/8/11
 * Time: 7:30 PM
 * Provides a nice method for issuing RESTful requests... like DELETE and others.
 */
var const_function_symbol = 'function';

var const_object_symbol = 'object';
var const_string_symbol = 'string';

function loadScripts() {
    var script2 = document.createElement("script");
    script2.type = "text/javascript";
    script2.src = "/javascripts/heat-map-utils.js";
    document.body.appendChild(script2);
}

function ezObjectExplainer(obj, bool_includeFuncs, _cnt) {
	var _db = '';
	var m = -1;
	var i = -1;
	var a = [];
	var cnt = ((_cnt == null) ? '1' : _cnt.toString() + '.0');
	bool_includeFuncs = ((bool_includeFuncs == true) ? bool_includeFuncs : false);

	function isCntComplex(c) {
		return (c.toString().indexOf('.') > -1);
	}

	_db = '';
    if (obj) {
        if ( (obj.toString != null) && ((typeof obj.toString) == const_function_symbol) && (obj.toString.toString().toLowerCase().indexOf('[native code]') == -1) ) {
            _db += obj.toString();
        } else {
            if ( (obj != null) && ((typeof obj) == const_object_symbol) ) {
                if (obj.length != null) {
                    for (i = 0; i < obj.length; i++) {
                        if ( ( (bool_includeFuncs) && ((typeof obj[i]) == const_function_symbol) ) || ( (!bool_includeFuncs) && ((typeof obj[i]) != const_function_symbol) ) ) {
                            a.push('[' + obj[i] + ']');
                        }
                    }
                } else {
                    for (m in obj) {
                        if ((typeof obj[m]) == const_object_symbol) {
                            a.push(m + ' = [' + ezObjectExplainer(obj[m], bool_includeFuncs, cnt) + ']');
                        } else if ( ( (bool_includeFuncs) && ((typeof obj[m]) == const_function_symbol) ) || ( (!bool_includeFuncs) && ((typeof obj[m]) != const_function_symbol) ) ) {
                            a.push(m + ' = [' + obj[m] + ']');
                        }
                    }
                }
                _db += a.join(((isCntComplex(cnt)) ? ',' : '\n'));
            } else if ( ( (bool_includeFuncs) && ((typeof obj) == const_function_symbol) ) || ( (!bool_includeFuncs) && ((typeof obj) != const_function_symbol) ) ) {
                _db += obj + '\n';
            }
        }
    }
	return _db;
}

function _ajax_request(url, data, callback, type, method) {
    _href_ = window.location.href;
    function _callback_(args) {
        alert(args);
    }
    function _onError_(jqXHR, textStatus, errorThrown) {
        alert("Error:\n"+'url='+url+',data='+ezObjectExplainer(data)+',type='+type+',method='+method+','+textStatus+'\n'+errorThrown);
    }
    if (jQuery.isFunction(data)) {
        callback = data;
        data = {};
    }
    return jQuery.ajax({
        type: method,
        url: url,
        data: data,
        success: _callback_,
        error: _onError_,
        dataType: type
    });
}
function uuid() {
	return (new Date().getTime() + "" + Math.floor(65535 * Math.random()));
}
/**
 * Heat Maps Support Code.
 * User: rhorn
 * Date: 9/8/11
 * Time: 7:30 PM
 */
var __map__;
var _model = {};

var __infowindow__;

var __defaultLatLng__;

var __is_loaded_heat_map_utils__ = false;

var __callback_heat_map_utils__ = function () {
	__is_loaded_heat_map_utils__ = true;
};

function initialize_heat_maps() {
	var __defaultLatLng__ = new google.maps.LatLng(37.331789, -122.029620);
	var myOptions = {
		zoom: 8,
		maxZoom: 15,
		minZoom: 8,
		streetViewControl: false,
		center: __defaultLatLng__,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	}
	var ele = $("#content-body > div:first");
	var h = ele.height();
	if (h == 0) {
		h = ele.css('height');
	}
	var w = ele.width();
	$('#map_canvas').css('width',w).css('height',400);
	__map__ = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
}
