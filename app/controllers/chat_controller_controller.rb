require 'unirest'

class ChatControllerController < ApplicationController
    skip_before_action :verify_authenticity_token

    access_token = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0Njk1NSwidGltZXN0YW1wIjoiMjAxOS0wNC0xOSAxNzowOTo0NiArMDAwMCJ9.J4z039nhHfvnRbzwPDebrPTf3nAsqX7GdpMZvgq9zUo'
    apiurl = 'https://qisme.qiscus.com/api/v1/chat/conversations/'
    headers = {
        'Content-Type' => 'application/json',
        'Content-Type' => 'multipart/form-data'
    }
    attr_accessor :qismeResponse

    def getResponse
        if request.headers['Content-Type'] == 'application/json'
            self.qismeResponse = JSON.parse(request.body.read)
        else
            # application/x-www-form-urlencoded
            self.qismeResponse = params.as_json
        end
        File.open('log-comment.txt','w') do |f|
            f.write(JSON.pretty_generate(self.qismeResponse))
        end    
    end
    
    def run
        self.getResponse
    end    
end
