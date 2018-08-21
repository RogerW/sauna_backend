# require 'uri'

class SendSmsWorker
  include Sidekiq::Worker

  def perform(id)
    sms = ShotMessage.find(id)

    # token = ShotMessagesToken.select(:token).where(created_at: (Time.now - 23.hour)..Time.now).first

    # if token.nil?
    #   request = Typhoeus::Request.new(
    #     'http://online.sigmasms.ru/api/login',
    #     method: :post,
    #     verbose: true,
    #     body: { username: 'gmurik2', password: 'wiwk2Lxt' }.to_json,
    #     headers: { Accept: 'application/json', 'Content-Type': 'application/json' }
    #   )

    #   # puts request

    #   request.on_complete do |response|
    #     # puts response
    #     # puts request
    #     if response.success?
    #       token = JSON.parse(response.body)['token']
    #       ShotMessagesToken.create(token: token)
    #       puts response.body

    #     elsif response.timed_out?
    #       # aw hell no
    #       puts('got a time out')
    #     elsif response.code == 0
    #       # Could not get an http response, something's wrong.
    #       puts 'login req'
    #       puts(response.return_message)
    #     else
    #       # Received a non-successful http response.
    #       puts('Login HTTP request failed: ' + response.code.to_s)
    #     end
    #   end

    #   request.run

    # else
    #   token = token.token
    # end
    # puts token

    sms.pend! if sms.may_pend?

    sms.process! if sms.may_process?

    if sms.may_send_sms?
      # request = Typhoeus::Request.new(
      #   'http://online.sigmasms.ru/api/sendings',
      #   method: :post,
      #   body: {
      #     recipient: '+79619436800',
      #     type: 'sms',
      #     payload: { sender: 'B-Media', text: sms.content }
      #   }.to_json,
      #   headers: {
      #     Accept: 'application/json',
      #     'Content-Type': 'application/json',
      #     Authorization: token
      #   }
      # )

      # request.on_complete do |response|
      #   if response.success?
      #     puts JSON.parse(response.body)
      #   elsif response.timed_out?
      #     # aw hell no
      #     puts('got a time out')
      #   elsif response.code == 0
      #     # Could not get an http response, something's wrong.
      #     puts(response.return_message)
      #   else
      #     # Received a non-successful http response.
      #     puts('Send SMS request failed: ' + response.code.to_s)
      #   end
      # end

      # request.run

      puts 'http://192.168.88.246/default/en_US/send.html' \
      "?u=admin&p=admin&l=1&n=#{CGI.escape(sms.phone)}" \
      "&m=#{CGI.escape(sms.content)}"

      request = Typhoeus::Request.new(
        'http://192.168.88.246/default/en_US/send.html' \
          "?u=admin&p=admin&l=1&n=#{CGI.escape(sms.phone)}" \
          "&m=#{CGI.escape(sms.content)}",
        method: :get
      )

      request.on_complete do |response|
        if response.success?
          puts response.body
        elsif response.timed_out?
          # aw hell no
          puts('got a time out')
        elsif response.code == 0
          # Could not get an http response, something's wrong.
          puts(response.return_message)
        else
          # Received a non-successful http response.
          puts('Send SMS request failed: ' + response.code.to_s)
        end
      end

      request.run

      # result = JSON.parse(result.body)
    end

    # reserv.complete! if reserv.may_complete?
  end
end
