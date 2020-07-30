require 'net/http'
require 'uri'
require 'json'

BASE_URL = "https://api.epersonate.com"
EPERSONATE_HEADER = 'x-epersonate';

class Epersonate
    def initialize(token)
        @personal_access_token = token
    end

    def verify(args)
        token = args[:token] || (args[:request] && args[:request].cookies[EPERSONATE_HEADER])
        unless token
            return {
                valid: false
            }
        end
        uri = URI.parse(BASE_URL + "/api/v1/impersonations")
        header = {
            'Content-Type': 'application/json',
            'Authorization': "Bearer " + @personal_access_token
        }
        body = {
            token: token
        }

        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Post.new(uri.request_uri, header)
        req.body = body.to_json
        response = http.request(req)
        if response.code == "200"
            return ActiveSupport::JSON.decode(response.body)
        end

        return {
            valid: false
        }
    end
end