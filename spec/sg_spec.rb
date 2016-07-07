require 'spec_helper'

module Sg
  describe CLI do
    it 'has a version number ' do
      expect(Sg::VERSION).not_to be nil
    end

    it 'GET https://api.sendgrid.com/v3/api_keys' do
      args = %w(client api_keys get)
      content = capture { CLI.start(args) }
      expect(content).to match(/result/)
    end

    it 'GET https://api.sendgrid.com/v3/api_keys/YOUR_API_KEY_ID' do
      args = %w(client api_keys example get)
      content = capture { CLI.start(args) }
      expect(content).to match(/errors/)
    end

    it 'GET https://api.sendgrid.com/v3/suppression/bounces?start_time=14324566&end_time=14324566' do
      args = [
        'client', 'suppression', 'bounces', 'get',
        '--query-params', '{"start_time":14324566,"&end_time":14324566}'
      ]
      content = capture { CLI.start(args) }
      expect(content).to match(/^\[.*\]$/)
    end

    it 'POST https://api.sendgrid.com/v3/api_keys' do
      args = [
        'client', 'api_keys', 'post',
        '--request-body', '{"name": "My API Key", "scopes": ["mail.send"]}'
      ]
      content = capture { CLI.start(args) }
      expect(content).to match(/api_key/)
    end

    it 'POST https://api.sendgrid.com/v3/mail/send' do
      args = [
        'client', 'mail', 'send', 'post',
        '--request-body', '{"personalizations":[{"to":[{"email":"to@example.com"}],"subject":"Hello, World!"}],"from":{"email":"from@example.com"},"content":[{"type":"text","value":"Hello, World!"}]}'
      ]
      content = capture { CLI.start(args) }
      expect(content).to match(//)
    end

    it 'GET https://api.sendgrid.com/v3/scopes' do
      args = [
        'client', 'scopes', 'get', '--user', 'hoge', '--pass', 'fuga'
      ]
      content = capture { CLI.start(args) }
      expect(content).to match(/authorization required/)
    end
  end
end
