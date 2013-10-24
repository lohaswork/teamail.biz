module EmailEngine
  class MailgunGateway

    def host_name
      Rails.env.production? ? "lohasWork.com" : "0.0.0.0:3000"
    end

    def send_batch_message(options={})
      RestClient.post(messaging_api_end_point,
          from: default_sender,
          to: delivery_filter(options[:to]),
          subject: options[:subject],
          html: options[:body]
          ) if send_email?

      Rails.logger.debug "Use #{default_sender} send email to #{delivery_filter(options[:to])} with subject: #{options[:subject]}\n And the content is: options[:body]"
    end

    private

    def send_email?
      !!$config.email
    end

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
