class ChatControllerController < ApplicationController
    access_token = ""
    apiurl = "https://qisme.qiscus.com/api/v1/chat/conversations/"
    headers = {
        "Content-Type" => "application/json",
        "Content-Type" => "multipart/form-data"
    }
    attr_accessor :qismeResponse

    
end
