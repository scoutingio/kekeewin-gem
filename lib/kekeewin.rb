require "kekeewin/version"

require 'oauth2'
require 'httparty'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/class/attribute'
require 'active_support/concern'

module Kekeewin

	module OauthAPI

    class << self
      def configure(&block)
        Kekeewin::OauthAPI::Base.configure(&block)
      end
    end

	  class Auth
	    attr :access_token
	    attr :oauth_client

	    def self.client(oauth_id = Base.oauth_id, oauth_secret = Base.oauth_secret, host = Base.host)
	      @oauth_client ||= OAuth2::Client.new(oauth_id, oauth_secret, site: host)
	    end

	    def self.access
	      @access_token ||= OAuth2::AccessToken.new(self.client, Base.access_token)
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

    class User
      def self.profile
        Auth.access.get("/api/me.json").parsed
      end
    end

    module Configuration
      extend ActiveSupport::Concern

      included do
        add_config :host
        add_config :oauth_id
        add_config :oauth_secret
        add_config :access_token
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
      include Kekeewin::OauthAPI::Configuration
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

      def districts(options={})
        options.merge!({:basic_auth => {:username => Base.username, :password => Base.password}})
        HTTParty.get(Base.host + "/rest_api/districts.json", options)
      end

      def lodges(options={})
        options.merge!({:basic_auth => {:username => Base.username, :password => Base.password}})
        HTTParty.get(Base.host + "/rest_api/lodges.json", options)
      end

      def chapters(options={})
        options.merge!({:basic_auth => {:username => Base.username, :password => Base.password}})
        HTTParty.get(Base.host + "/rest_api/chapters.json", options)
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
