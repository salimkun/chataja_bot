require 'unirest'

class ChatControllerController < ApplicationController
    skip_before_action :verify_authenticity_token

    access_token = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0Njk1NSwidGltZXN0YW1wIjoiMjAxOS0wNC0xOSAxNzowOTo0NiArMDAwMCJ9.J4z039nhHfvnRbzwPDebrPTf3nAsqX7GdpMZvgq9zUo'
    apiurl = 'https://qisme.qiscus.com/api/v1/chat/conversations/'
    headers = headers:{ 
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

    def replyCommandButton(display_name,room_id)
        comment = 'Halo, '+display_name+' ini adalah contoh payload button yang bisa kamu coba'
        payload = {
            'text' => comment,
            'buttons' => [
                {
                    "label" => "Tombol Reply Text",
                    "type" => "postback",
                    "payload" => [
                        "url" => "#",
                        "method" => "get",
                        "payload" => "null"
                    ]
                },
                {
                    "label" => "Tombol Link",
                    "type" => "link",
                    "payload" => [
                        "url" => "https://www.google.com",
                    ]
                }
            ]
        }
        replay = parameters:{ 
            'access_token' => self.access_token
            'topic_id' => room_id
            'payload' => payload 
        }
        post_comment = Unirest.post self.apiurl, self.headers, replay
    end    
    
    def run
        self.getResponse
    end    
end
