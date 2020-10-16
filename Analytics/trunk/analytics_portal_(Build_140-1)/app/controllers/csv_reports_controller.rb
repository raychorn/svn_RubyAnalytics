require 'uri'
require 'net/http'
require 'net/https'

class CsvReportsController < ActionController::Base
 # skip_authorization_check

  def index
    respond_to do |format|
      format.html { render :layout => 'application' }
    end
  end

  def sample
    respond_to do |format|
      format.json  { render :json => {:status => 'ok'}, :status => :ok }
    end
  end

  def dorequest
    data = ''
    resp = {:code => '-1'}
    if @_request.method == 'POST' then
      begin
        __url__ = @_request.filtered_parameters['__url__']
        _data = []
        @_request.filtered_parameters.each_pair do |k,v|
          if k != '__url__' then
            _item = ''
            _item << k
            _item << '='
            _item << URI.escape(v, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
            _data << _item
          end
        end
        url = URI.parse(__url__)
        if (url.scheme.downcase.casecmp('https') == 0) then
          http = Net::HTTPS.new(url.host, url.port)
        else
          http = Net::HTTP.new(url.host, url.port)
        end

        data = _data * "&"
        headers = {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
        resp, data = http.post(url.path, data, headers)
        _error_ = ''
      rescue
        _error_ = "ERROR: #{$!}"
      end
    end
    respond_to do |format|
      format.json  { render :json => {:status => 'ok',:response => resp.code,:data => data,:error => _error_}, :status => :ok }
    end
  end

end
