module Etsy
  module Model # :nodoc:all

    module ClassMethods

      def attribute(name, options = {})
        define_method name do
          @result[options.fetch(:from, name).to_s]
        end
      end

      def attributes(*names)
        names.each {|name| attribute(name) }
      end

      def get(endpoint, options = {})
        objects = get_all(endpoint, options)
        (objects.length == 1) ? objects[0] : objects
      end

      def get_all(endpoint, options={})
        response = Request.get(endpoint, options)
        [response.result].flatten.map do |data|
          if options[:access_token] && options[:access_secret]
            new(data, options[:access_token], options[:access_secret])
          else
            new(data)
          end
        end
      end

      def find_one_or_more(endpoint, identifiers_and_options)
        options = options_from(identifiers_and_options)
        identifiers = identifiers_and_options
        get("/#{endpoint}/#{identifiers.join(',')}", options)
      end

      def options_from(argument)
        (argument.last.class == Hash) ? argument.pop : {}
      end

    end

    def initialize(result = nil, token = nil, secret = nil)
      @result = result
      @token = token
      @secret = secret
    end

    def token
      @token
    end

    def secret
      @secret
    end

    def self.included(other)
      other.extend ClassMethods
    end

  end
end
