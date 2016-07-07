require 'base64'
require 'thor'
require 'sendgrid-ruby'
require 'sg/version'

module Sg
  #
  # SendGrid Command Line Interface Class
  #
  class CLI < Thor
    desc(
      'client *PATH_TO_THE_ENDPOINT VERB',
      'Call SendGrid Web API v3 from command line interface'
    )
    long_desc <<-DESC
      1. Simple GET call
      \x5Use the client command with path after v3 level with space.
      Then add the HTTP verb at the end of the command.
      \x5GET https://api.sendgrid.com/v3/api_keys
      \x5> $ bundle exec sg client api_keys get

      2. With variable
      \x5Use the client command with the variable values.
      Then add the HTTP verb at the end of the command.
      \x5GET https://api.sendgrid.com/v3/api_keys/YOUR_API_KEY_ID
      \x5> $ bundle exec sg client api_keys YOUR_API_KEY_ID get

      3. With query string
      \x5Use -q option for the query string with the JSON string value.
      \x5GET https://api.sendgrid.com/v3/suppression/bounces?start_time=14324566&end_time=14324566
      \x5> $ bundle exec sg client suppression unsubscribes get -q='{"start_time":1367794504,"end_time":1467794504}'

      4. With request body
      \x5Use -b option for the request body with the JSON string value.
      \x5POST https://api.sendgrid.com/v3/api_keys
      \x5{"name": "My API Key", "scopes": ["mail.send"]}
      \x5> $ bundle exec sg client api_keys post -b='{"name": "My API Key", "scopes": ["mail.send"]}'

      5. Send mail
      \x5> $ sg client mail send post -b='{"personalizations":[{"to":[{"email":"to@example.com"}],"subject":"Hello, World!"}],"from":{"email":"from@example.com"},"content":[{"type":"text","value":"Hello, World!"}]}'
    DESC
    option(
      :apikey,
      aliases: '-k',
      desc: 'API Key. Load env variable "SENDGRID_API_KEY" if not specified.'
    )
    option :user, aliases: '-u', desc: 'Username for Basic Auth.'
    option :pass, aliases: '-p', desc: 'Password for Basic Auth.'
    option :request_body, aliases: '-b', desc: 'Request Body'
    option(
      :query_params,
      aliases: '-q',
      desc: 'Query String of the request',
      banner: 'JSON_STRING'
    )
    option(
      :response_header,
      aliases: '-h',
      desc: 'Output response header',
      banner: ''
    )
    option(
      :response_status,
      aliases: '-s',
      desc: 'Output reponse status code',
      banner: ''
    )
    option :version, aliases: '-v', desc: 'Output gem version', banner: ''
    def client(*args)
      return puts Sg::VERSION if options[:version]
      idx = 0
      params = CLI.parameterise(options)
      response = args.inject(CLI.get_client(options)) do |c, arg|
        idx += 1
        (args.length == idx) ? c.send(arg, params) : c.send('_', arg)
      end
      puts response.status_code if options[:response_status]
      puts response.headers if options[:response_header]
      puts response.body
    end

    def self.parameterise(options)
      options.each_with_object({}) do |(k, v), memo|
        if k.to_s == 'request_body' || k.to_s == 'query_params'
          memo[k.to_s.to_sym] = JSON.parse(v) unless v.nil?
        end
      end
    end

    def self.get_client(options)
      if options[:user] && options[:pass]
        up = "#{options[:user]}:#{options[:pass]}"
        headers = {}
        headers['Authorization'] = "Basic #{Base64.urlsafe_encode64(up)}"
        SendGrid::API.new(api_key: '', request_headers: headers).client
      else
        api_key = options[:apikey]
        api_key ||= ENV['SENDGRID_API_KEY']
        SendGrid::API.new(api_key: api_key).client
      end
    end
  end
end
