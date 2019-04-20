require 'unirest'

class ChatControllerController < ApplicationController
    skip_before_action :verify_authenticity_token 
    attr_accessor :qismeResponse, :access_token, :apiurl, :headers

    def initialize()
        @access_token = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0Njk1NSwidGltZXN0YW1wIjoiMjAxOS0wNC0wNSAwNjoxMjo0MSArMDAwMCJ9.u5PHjfNPrRL_nhh5S-UUSNLBr2kKBlBI89px2L2jjdg'
        @apiurl = 'https://qisme.qiscus.com/api/v1/chat/conversations/'
        @headers = { 
            'Content-Type' => 'application/json'
        }
    end    

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

    def replyCommandButton(display_name, room_id)
        comment = 'Halo, '+display_name+' ini adalah contoh payload button yang bisa kamu coba'
        payload = {
            'text' => comment,
            'buttons' => [
                {
                    'label' => 'Tombol Reply Text',
                    'type' => 'postback',
                    'payload' => [
                        'url' => '#',
                        "method" => 'get',
                        'payload' => 'null'
                    ]
                },
                {
                    'label' => 'Tombol Link',
                    'type' => 'link',
                    'payload' => [
                        'url' => 'https://www.google.com',
                    ]
                }
            ]
        }
        replay = { 
            'access_token' => self.access_token,
            'topic_id' => room_id,
            'type' => 'buttons',
            'payload' => payload.to_json
        }
        post_comment = Unirest.post(self.apiurl+"post_comment", headers: self.headers, parameters: replay)
        render :json => post_comment.raw_body
    end
    
    def replyCommandText(display_name, message_type, room_id)
        comment = 
        'Maaf '+display_name+', command yang kamu ketik salah. Jenis pesan kamu adalah '+message_type+'. Silahkan coba command berikut :\n'+
        '/location, /button, /card, /carousel'

        replay = {
            'access_token' => self.access_token,
            'topic_id' => room_id,
            'type' => 'text',
            'comment' => comment
        }
        post_comment = Unirest.post(self.apiurl+"post_comment", headers: self.headers, parameters: replay)
        render :json => post_comment.raw_body
    end
    
    def run
        self.getResponse
        chat = Chat.new(
            self.qismeResponse['chat_room']['qiscus_room_id'],
            self.qismeResponse['message']['text'],
            self.qismeResponse['message']['type'],
            self.qismeResponse['from']['fullname']
        )
        #self.replyCommandButton(chat.sender, chat.room_id)
        self.replyCommandText(chat.sender, chat.message_type, chat.room_id)
    end    
end
