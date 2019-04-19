require 'unirest'

class ChatControllerController < ApplicationController
    access_token = ''
    apiurl = 'https://qisme.qiscus.com/api/v1/chat/conversations/'
    headers = {
        'Content-Type' => 'application/json',
        'Content-Type' => 'multipart/form-data'
    }
    attr_accessor :qismeResponse

    private
    def getResponse
        if request.headers['Content-Type'] == 'application/json'
            self.qismeResponse = JSON.parse(request.body.read)
        else
            # application/x-www-form-urlencoded
            self.qismeResponse = params.as_json
        end
        File.open('log-comment.txt','w') do |f|
            f.write(self.qismeResponse)
        end    
    end
    
    public
    def run
        self.getResponse
    end    
end
