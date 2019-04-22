require 'unirest' #panggil depedensi unirest

class ChatControllerController < ApplicationController
    skip_before_action :verify_authenticity_token #skip verify token rails
    attr_accessor :qismeResponse, :access_token, :apiurl, :headers #set-get atribut controller

    #inisiasi nilai atribut
    def initialize()
        @access_token = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0Njk1NSwidGltZXN0YW1wIjoiMjAxOS0wNC0wNSAwNjoxMjo0MSArMDAwMCJ9.u5PHjfNPrRL_nhh5S-UUSNLBr2kKBlBI89px2L2jjdg'
        @apiurl = 'https://qisme.qiscus.com/api/v1/chat/conversations/'
        @headers = { 
            'Content-Type' => 'application/json'
        }
    end    

    #ambil dan tampung response data dari webhook
    def getResponse
        if request.headers['Content-Type'] == 'application/json'
            self.qismeResponse = JSON.parse(request.body.read)
        else
            #application/x-www-form-urlencoded
            self.qismeResponse = params.as_json
        end

        #siapkan log untuk memastikan data terambil
        File.open('log-comment.txt','w') do |f|
            f.write(JSON.pretty_generate(self.qismeResponse))
        end    
    end

    #contoh penggunaan api post-comment untuk jenis button
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
                        'method' => 'get',
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
        post_comment = Unirest.post(self.apiurl+'post_comment', headers: self.headers, parameters: replay)
        render :json => post_comment.raw_body
    end
    
    #contoh penggunaan api post-comment untuk jenis text
    def replyCommandText(display_name, message_type, room_id)
        comment = 
        'Maaf '+display_name+', command yang kamu ketik salah. Jenis pesan kamu adalah '+message_type+'. Silahkan coba command berikut : '+
        '/location, /button, /card, /carousel'

        replay = {
            'access_token' => self.access_token,
            'topic_id' => room_id,
            'type' => 'text',
            'comment' => comment
        }
        post_comment = Unirest.post(self.apiurl+'post_comment', headers: self.headers, parameters: replay)
        render :json => post_comment.raw_body
    end

    #contoh penggunaan api post-comment untuk jenis location
    def replyCommandLocation(room_id)
        payload = {
            'name' => 'Telkom Landmark Tower',
            'address' => 'Jalan Jenderal Gatot Subroto No.Kav. 52, West Kuningan, Mampang Prapatan, South Jakarta City, Jakarta 12710',
            'latitude' => '-6.2303817',
            'longitude' => '106.8159363',
            'map_url' => 'https://www.google.com/maps/@-6.2303817,106.8159363,17z'
        }
        replay = {
            'access_token' => self.access_token,
            'topic_id' => room_id,
            'type' => 'location',
            'payload' => payload.to_json
        }
        location  = Unirest.post(self.apiurl+'post_comment', headers: self.headers, parameters: replay);
        render :json => location.raw_body
    end
    
    #contoh penggunaan api post-comment untuk jenis carousel
    def replyCommandCarousel(room_id)
        payload = {
            'cards' => [
                {
                    'image' => 'https://cdns.img.com/a.jpg',
                    'title' => 'Gambar 1',
                    'description' => 'Carousel Double Button',
                    'default_action' => {
                        'type' => 'postback',
                        'postback_text' => 'Load More...',
                        'payload' => {
                            'url' => 'https://j.id',
                            'method' => 'GET',
                            'payload'=> nil
                        }
                    },
                    'buttons' => [
                        {
                            'label' => 'Button 1',
                            'type' => 'postback',
                            'postback_text' => 'Load More...',
                            'payload' => {
                                'url' => 'https://www.r.com',
                                'method' => 'GET',
                                'payload' => nil
                            }
                        },
                        {
                            'label' => 'Button 2',
                            'type' => 'postback',
                            'postback_text' => 'Load More...',
                            'payload' => {
                                'url' => 'https://www.r.com',
                                'method' => 'GET',
                                'payload' => nil
                            }
                        }
                    ]
                },
                {
                    'image' => 'https://res.cloudinary.com/hgk8.jpg',
                    'title' => 'Gambar 2',
                    'description' => 'Carousel single button',
                    'default_action' => {
                        'type' => 'postback',
                        'postback_text' => 'Load More...',
                        'payload' => {
                            'url' => 'https://j.id',
                            'method' => 'GET',
                            'payload'=> nil
                        }
                    },
                    'buttons' => [
                        {
                            'label' => 'Button 1',
                            'type' => 'postback',
                            'postback_text' => 'Load More...',
                            'payload' => {
                                'url' => 'https://www.r.com',
                                'method' => 'GET',
                                'payload' => nil
                            }
                        }
                    ]
                }
            ]
        }
        replay = {
            'access_token' => self.access_token,
            'topic_id' => room_id,
            'type' => 'carousel',
            'payload' => payload.to_json
        }
        carousel = Unirest.post(self.apiurl+'post_comment', headers: self.headers, parameters: replay);
        render :json => carousel.raw_body
    end

    #contoh penggunaan api post-comment untuk jenis card
    def replyCommandCard(room_id)
        payload = {
            'text' => 'Special deal buat sista nih..',
            'image' => 'https://cdns.img.com/a.jpg',
            'title' => 'Gambar 1',
            'description' => 'Card Double Button',
            'url' => 'http://url.com/baju?id=123%26track_from_chat_room=123',
            'buttons' => [
                {
                    'label' => 'Button 1',
                    'type' => 'postback',
                    'postback_text' => 'Load More...',
                    'payload' => {
                        'url' => 'https://www.r.com',
                        'method' => 'GET',
                        'payload' => nil
                    }
                },
                {
                    'label' => 'Button 2',
                    'type' => 'postback',
                    'postback_text' => 'Load More...',
                    'payload' => {
                        'url' => 'https://www.r.com',
                        'method' => 'GET',
                        'payload' => nil
                    }
                }
            ]
        }
        replay = {
            'access_token' => self.access_token,
            'topic_id' => room_id,
            'type' => 'card',
            'payload' => payload.to_json
        }
        card  = Unirest.post(self.apiurl+'post_comment', headers: self.headers, parameters: replay);
        render :json => card.raw_body
    end

    #fungsi untuk jalankan bot
    def run
        self.getResponse 
        chat = Chat.new(
            self.qismeResponse['chat_room']['qiscus_room_id'],
            self.qismeResponse['message']['text'],
            self.qismeResponse['message']['type'],
            self.qismeResponse['from']['fullname']
        )
        
        #cek pesan dari chat tidak kosong & cari chat yang mengandung '/' untuk menjalankan command bot
        find_slash = chat.message.scan('/')
        if chat.message != nil && find_slash[0] == '/'
            #ambil nilai text setelah karakter '/'
            command = chat.message.split('/')
            if command[1] != nil
                case command[1]
                    when 'location'
                        self.replyCommandLocation(chat.room_id)
                    when 'carousel'
                        self.replyCommandCarousel(chat.room_id)
                    when 'button'
                        self.replyCommandButton(chat.sender, chat.room_id)
                    when 'card'
                        self.replyCommandCard(chat.room_id)
                    else
                        self.replyCommandText(chat.sender, chat.message_type, chat.room_id)            
                end
            else
                self.replyCommandText(chat.sender, chat.message_type, chat.room_id)
            end
        end
    end    
end
