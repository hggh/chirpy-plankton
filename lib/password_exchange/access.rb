require 'ipaddr'

module PasswordExchange
  class Access
    class NoAccessIPMissing<RuntimeError;end
    class NoAccessIPBlacklisted<RuntimeError;end
    class NoAccessInvalidIpAddress<RuntimeError;end
    class NoAccessInvalidBrowserAgent<RuntimeError;end
    class NoSSLAccessInProduction<RuntimeError;end

    def initialize(config)
      @config = config
    end

    def access?(ip, browser_agent)
      begin
        if ip == ""
          raise NoAccessIPMissing
        end
        check_ip_access(ip)
        check_browser_agent(browser_agent)
      rescue Exception => e
        no_access(e)
      end
      true
    end

    def no_access(e)
      throw :halt, [ 400, 'Bad Request:' + e.to_s  ]
    end

    private

    def check_browser_agent(browser_agent)
      if @config.access['browser_agent'] and @config.access['browser_agent'].is_a?(Array) and @config.access['browser_agent'].size > 0
        @config.access['browser_agent'].each do |str|
          rexp = Regexp.new(str)
          if rexp.match(browser_agent)
            raise NoAccessInvalidBrowserAgent
          end
        end
      end
    end

    def check_ip_access(ip)
      begin
        ipaddr = IPAddr.new(ip)
      rescue ArgumentError
        raise NoAccessInvalidIpAddress
      end
      if !ipaddr.ipv4? and !ipaddr.ipv6?
        raise NoAccessInvalidIpAddress
      end
      if ipaddr.ipv4? and @config.access['blacklist_ip']['v4'].is_a?(Array) and @config.access['blacklist_ip']['v4'].size > 0
        @config.access['blacklist_ip']['v4'].each do |network|
          net = IPAddr.new(network)
          if net.include?(ipaddr.to_s)
            raise NoAccessIPBlacklisted
          end
        end
      end
      if ipaddr.ipv6? and @config.access['blacklist_ip']['v6'].is_a?(Array) and @config.access['blacklist_ip']['v6'].size > 0
        @config.access['backlist_ip']['v6'].each do |network|
          net = IPAddr.new(network)
          if net.include?(ipaddr.to_s)
            raise NoAccessIPBlacklisted
          end
        end
      end
    end
  end
end
