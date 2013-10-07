require "kekeewin/version"

require 'oauth2'
require 'httparty'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/class/attribute'
require 'active_support/concern'

module Kekeewin

  class Auth
    attr :access_token
    attr :oauth_client

    def initialize(oauth_id = "ccd5cf853a2b5ddbb523da179376ef65467b6affc7b68b7fab647211c002a337", oauth_secret = "ed2a8299d31fb35d3a4f07f46eb0f1e1460ee49e98621a5b9dccfa6b56157ce3", host = "http://kekeewin.dev")
      @oauth_client ||= OAuth2::Client.new(oauth_id, oauth_secret, site: host)
    end

    def self.access
      @access_token ||= OAuth2::AccessToken.new(@oauth_client, @access_token)
    end 

    def self.hello
      return "Hello, World!"
    end
  end

  class Lodge
    def self.all
      @lodges ||= Auth.access.get("/api/lodges").parsed
    end

    def self.test
      return Auth.hello
    end
  end

  module RestAPI

    class << self
      def configure(&block)
        Kekeewin::RestAPI::Base.configure(&block)
      end

      def councils(options={})
        options.merge!({:basic_auth => {:username => Base.username, :password => Base.password}})
        HTTParty.get(Base.host + "/rest_api/councils.json", options)
      end

      def lodges(options={})
        options.merge!({:basic_auth => {:username => Base.username, :password => Base.password}})
        HTTParty.get(Base.host + "/rest_api/lodges.json", options)
      end

      def positions(options={})
        options.merge!({:basic_auth => {:username => Base.username, :password => Base.password}})
        HTTParty.get(Base.host + "/rest_api/positions.json", options)
      end


    end
    module Configuration
      extend ActiveSupport::Concern

      included do
        add_config :host
        add_config :username
        add_config :password

        # set default values
        reset_config
      end

      module ClassMethods
        def add_config(name)
          class_eval <<-RUBY, __FILE__, __LINE__ + 1

            def self.#{name}(value=nil)
              @#{name} = value if value
              return @#{name} if self.object_id == #{self.object_id} || defined?(@#{name})
              name = superclass.#{name}
              return nil if name.nil? && !instance_variable_defined?("@#{name}")
              @#{name} = name && !name.is_a?(Module) && !name.is_a?(Symbol) && !name.is_a?(Numeric) && !name.is_a?(TrueClass) && !name.is_a?(FalseClass) ? name.dup : name
            end

            def self.#{name}=(value)
              @#{name} = value
            end

            def #{name}=(value)
              @#{name} = value
            end

            def #{name}
              value = @#{name} if instance_variable_defined?(:@#{name})
              value = self.class.#{name} unless instance_variable_defined?(:@#{name})
              if value.instance_of?(Proc)
                value.arity >= 1 ? value.call(self) : value.call
              else 
                value
              end
            end
          RUBY
        end

        def configure
          yield self
        end

        def reset_config
          configure do |config|
            config.host = "http://kekeewin.dev"
          end
        end
      end
    end

    class Base
      include Kekeewin::RestAPI::Configuration
    end
  end
end
