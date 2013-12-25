module EmailEngine
  class MailgunGateway

    def host_name(port_name = true)
      if Rails.env.production?
        "teamail.biz"
      elsif Rails.env.staging?
        "121.199.16.68"
      elsif port_name
        "0.0.0.0:3000"
      else
        "0.0.0.0"
      end
    end

    def protocol
      (Rails.env.production? || Rails.env.staging?) ? "https" : "http"
    end

    def send_batch_message(options={})
      RestClient.post(messaging_api_end_point,
          from: options[:from] || ("teamail.biz" + " " + $config.default_system_email),
          to: delivery_filter(options[:to]),
          subject: options[:subject],
          html: options[:body],
          'h:Message-Id' => options[:message_id],
          'h:In-Reply-To' => options[:in_reply_to],
          'h:Reference' => options[:in_reply_to]
          ) if send_email?

      #Rails.logger.debug "Use #{default_sender} send email to #{delivery_filter(options[:to])} with subject: #{options[:subject]}\n And the content is: options[:body]"
    end

    private

    def send_email?
      !!$config.email
    end

    def api_key
      @api_key ||= $config.mailgun_api_key
    end

    def messaging_api_end_point
      @messaging_api_end_piont ||= "https://api:#{api_key}@api.mailgun.net/v2/mail.teamail.biz/messages"
    end

    def delivery_filter(emails)
      (Rails.env.production? || Rails.env.staging?) ? emails : $config.receive_test_email
    end
  end
end
