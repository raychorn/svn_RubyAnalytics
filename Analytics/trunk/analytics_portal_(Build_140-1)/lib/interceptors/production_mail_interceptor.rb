require 'uri'
require 'socket'

def local_ip
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

  UDPSocket.open do |s|
    s.connect '64.233.187.99', 1
    s.addr.last
  end
ensure
  Socket.do_not_reverse_lookup = orig
end

class ProductionMailInterceptor
  def self.delivering_email(message)
    message.subject = "[#{message.to}] #{message.subject}"
    r_email = Regexp.new(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/)
    r_href = Regexp.new(/<a href="(.*)">.*<\/a>/)
    _content = message.body.to_s
    emails = _content.scan(r_email).uniq
    hrefs = _content.scan(r_href).uniq
    urls = URI.extract(_content, ['http', 'https'])
    if (emails.length > 0) and (hrefs.length > 0) and (urls.length > 0) then
      _ip_ = local_ip
      _t_ = urls[-1].split('//')[-1].split('/')[0].split(':')[0]
      _u_ = urls[-1].sub(_t_,_ip_)
      _content = _content.sub(urls[-1],_u_)
      _t_ = urls[0].split('//')[-1].split('/')[0].split(':')[0]
      _u_ = urls[0].sub(_t_,_ip_)
      _content = _content.sub(urls[0],_u_)
      message.body = _content
    end
  end
end