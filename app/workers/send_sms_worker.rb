# require 'uri'

class SendSmsWorker
  include Sidekiq::Worker

  def perform(id)
    sms = ShotMessage.find(id)

    sms.pend! if sms.may_pend?

    sms.process! if sms.may_process?

    if sms.may_send_sms?

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
