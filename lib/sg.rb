require 'thor'
require 'sendgrid-ruby'
require 'sg/version'

module Sg
  #
  # SendGrid Command Line Interface Class
  #
  class CLI < Thor
    desc 'client', 'Call SendGrid Web API v3 from command line interface'
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
