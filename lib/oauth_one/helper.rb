require 'active_support/core_ext/hash/reverse_merge'
require 'addressable/uri'
require 'cgi'
require 'base64'
require 'openssl'
require 'securerandom'
require 'net/http'

module OauthOne

  class Helper
    attr_reader :url_params
    attr_reader :method

    def initialize(method, url, params, options)
      options.reverse_update({
        version: "1.0",
        signature_method: 'HMAC-SHA1',
        timestamp: Time.now.to_i.to_s,
        nonce: SecureRandom.uuid
      })

      @consumer_secret = options.delete(:consumer_secret)
      @token_secret = options.delete(:token_secret)
      @url_params = params.merge(prepend_oauth_to_key(options))
      @method = method.to_s.upcase
      @url = Addressable::URI.parse(url)
    end

    def signature_base
      @url_params.delete(:oauth_signature)
      [@method, @url.to_s, url_with_params.query].map{|v| CGI.escape(v) }.join('&')
    end

    def full_url
      append_signature_to_params
      url_with_params.to_s
    end

    def make_request
      oauth_signature = CGI.escape(Base64.encode64("#{OpenSSL::HMAC.digest('sha1',self.url_params[:oauth_consumer_key], self.signature_base)}").chomp)
      urlm = URI(self.full_url )
      http = Net::HTTP.new(urlm.host, urlm.port)
      method_type = self.method.to_s.capitalize
      http_obj = "Net::HTTP::#{method_type}".classify.constantize
      request = http_obj.new(urlm)
      request["cache-control"] = 'no-cache'
      http.use_ssl = (urlm.scheme == "https")
      response = http.request(request)
      obj = JSON.parse(response.read_body)
    end
    

    private
      def key
        @token_secret ? "#{CGI.escape(@consumer_secret)}&#{CGI.escape(@token_secret)}" : "#{CGI.escape(@consumer_secret)}&"
      end

      def url_with_params
        @url.dup.tap{|url| url.query_values = url_params}
      end

      def append_signature_to_params
        @url_params[:oauth_signature] = hmac_sha1_signature(key, signature_base)
      end

      def prepend_oauth_to_key(options)
        Hash[options.map{|key, value| ["oauth_#{key}".to_sym, value]}]
      end

      def hmac_sha1_signature(key, signature_string)
        digest = OpenSSL::Digest.new('sha1')
        hmac = OpenSSL::HMAC.digest(digest, key, signature_string)
        Base64.encode64(hmac).chomp.gsub(/\n/, '')
      end
  end
end
