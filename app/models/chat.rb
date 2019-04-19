class Chat < ApplicationRecord
    attr_read :room_id, :message, :message_type, :sender

    def initialize(room_id, message, message_type, sender)
        @room_id = room_id
        @message = message
        @message_type = message_type
        @sender = sender
    end    
end
