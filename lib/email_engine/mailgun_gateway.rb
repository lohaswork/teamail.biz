module EmailEngine
  class MailgunGateway
    def send_batch_message(options={})
      RestClient.post(messaging_api_end_point,
          from: default_sender,
          to: delivery_filter(options[:to]),
          subject: options[:subject],
          html: options[:body]
          )
    end

    private

    def default_sender
      "LohasWork <notice@charleschu.mailgun.org>"
    end

    def api_key
      @api_key ||= $config.mailgun_api_key
    end

    def messaging_api_end_point
      @messaging_api_end_piont ||= "https://api:#{api_key}@api.mailgun.net/v2/charleschu.mailgun.org/messages"
    end

    def delivery_filter(emails)
      Rails.env.production? ? emails : $config.recieve_test_email
    end
  end
end
