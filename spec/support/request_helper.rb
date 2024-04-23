module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end
  end

  module HeaderHelpers
    def authorized_header(user)
      token = JwtService.encode({ user_id: user.id })
      return { 'Authorization' => "Bearer #{token}" }
    end

    def unauthorized_header
      return { 'content-type' => 'application/json' }
    end

    def rest_client_headers
      return { 
        'Accept'=>'*/*',
        'Content-Type'=>'application/json',
        }
    end
  end
end

RSpec.configure do |config|
  config.include Requests::HeaderHelpers, type: :controller
  config.include Requests::JsonHelpers, type: :controller
end
