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
      \x5> $ bundle exec sg client suppression bounces get -q='{"start_time": 14324566, "end_time": 14324566}'

      4. With request body
      \x5Use -b option for the request body with the JSON string value.
      \x5POST https://api.sendgrid.com/v3/api_keys
      \x5{"name": "My API Key", "scopes": ["mail.send"]}
      \x5> $ bundle exec sg client api_keys post -b='{"name": "My API Key", "scopes": ["mail.send"]}'
    DESC
    option(
      :apikey,
      aliases: '-k',
      desc: 'API Key. Use env variable "SENDGRID_API_KEY" if not specified.'
    )
    option :request_body, aliases: '-b', desc: 'Request Body'
    option :query_params, aliases: '-q', desc: 'Query String of the request'
    option :response_header, aliases: '-h', desc: 'Output response header'
    option :response_status, aliases: '-s', desc: 'Output reponse status code'
    option :version, aliases: '-v', desc: 'Output gem version'
    def client(*args)
      return puts Sg::VERSION if options[:version]
      api_key = options[:apikey]
      api_key ||= ENV['SENDGRID_API_KEY']
      sg = SendGrid::API.new(api_key: api_key)
      idx = 0
      response = args.inject(sg.client) do |c, arg|
        idx += 1
        (args.length == idx + 1) ? c.send(arg, options) : c.send(arg)
      end
      puts response.status_code if options[:response_status]
      puts response.headers if options[:response_header]
      puts response.body
    end
  end
end
