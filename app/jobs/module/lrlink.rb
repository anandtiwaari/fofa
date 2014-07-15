# encoding: utf-8
require 'domainatrix'
require 'uri'

module Lrlink
  def get_domain_info_by_host(host)
    url = Domainatrix.parse(host)
    if url.domain && url.public_suffix
      return url
    end
    nil
  end

  def host_of_url(url)
    begin
      url = 'http://'+url+'/' if !url.include?('http://') and !url.include?('https://')
      url = URI.encode(url) unless url.include? '%' #如果包含百分号%，说明已经编码过了
      uri = URI(url)
      uri.host
    rescue => e
      nil
    end
  end

  def hostinfo_of_url(url)
    begin
      url = 'http://'+url+'/' if !url.include?('http://') and !url.include?('https://')
      url = URI.encode(url) unless url.include? '%' #如果包含百分号%，说明已经编码过了
      uri = URI(url)
      rr = uri.host
      rr = rr+':'+uri.port.to_s if uri.port!=80 && uri.port!=443
      rr
    rescue => e
      nil
    end
  end

  def get_linkes(html)
    arr = []
    if html
      html.scan(/(http[s]?:\/\/.*?)[ \/\'\"\>]/).each{|x|
        if x[0].size>8 && x[0].include?('.')
          hostinfo = hostinfo_of_url(x[0].downcase)
          arr << hostinfo if hostinfo
        end
      }
    end
    arr.uniq
  end

  def is_bullshit_host?(host)
    $hosts = %w|.i.sohu.com .tumblr.com .soufun.com .ymjx168.com .ninemarket.com .12market.com .cailiao.com .taobao.com .blogfa.com .parsiblog.com .blog.ir .mihanblog.com .persianblog.ir .niniweblog.com .lapozz.hu .blogcu.com .blogsky.com .deviantart.com rpod.ru .beon.ru .ieskok.lt .vk.me .qaix.com .gyxu.com .ltalk.ru .userapi.com .olx.bg .digart.pl .flog.pl .fmix.pl .uol.ua .rock.cz .blog.is .yjycw.com .243mm.com .bxlwt.com .mmfj.com .blox.pl .bloog.pl .huamu.cn .8671.net .blog.pl .onet.pl .salon24.pl|
    $hosts.each{|h|
      return true if host.include?(h)
    }
    false
  end

  def is_bullshit_ip?(ip)
    $ips = %w|192.126.115. 198.204.238. 192.151.145. 146.71.35. 23.245.66. 42.121.52. 208.66.76. 162.255.181. 107.148.40. 108.186.70. 107.149.82. 204.12.248. 122.9.125. 159.63.88. 69.90.191. 76.74.218. 162.211.24. 107.6.46. 142.54.190. 198.204.234. 8.5.1. 64.74.223. 23.82.61. 174.139.171. 107.183.22. 103.240.183. 192.169.109. 199.182.234. 23.81.36. 23.248.213. 107.163.136. 107.163.132. 103.248.36. 107.149.121. 101.226.10. 23.27.192. 219.139.130. 146.148.150. 146.148.151. 146.148.152. 146.148.153. 107.183.41. 23.224.45. 116.212.115. 23.110.102. 198.56.177. 107.181.245. 107.181.242. 107.160.38. 142.0.142. 103.244.148. 23.80.51. 67.229.62. 144.76.203. 74.82.63. 103.24.92. 23.105.79. 107.183.152. 107.189.149. 107.189.134. 107.189.154. 107.149.155. 23.238.206. 23.228.225. 23.228.219. 198.13.100. 192.169.105. 69.12.87. 23.245.134. 69.12.87. 172.240.95. 174.139.6. 173.208.68. 115.126.23. 108.62.237. 173.208.68. 172.240.60. 107.178.159.|
    $ips.each{|bip|
      return true if ip.include?(bip)
    }
    false
  end

end