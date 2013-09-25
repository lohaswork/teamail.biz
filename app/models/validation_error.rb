class ValidationError < StandardError
  def initialize(error)
    @messages = []
    return if !error
    if error.instance_of? ActiveRecord::RecordInvalid
      load_from_ar_errors(error)
    else
      add(error)
    end
  end

  def message
    @messages
  end

  def add(error)
    if error.instance_of? Array
        error.each { |m| add(m) }
    else
      @messages << "#{error}"
    end
  end

  def load_from_ar_errors(ar_error)
    #TODO: handle the active recode error message here
    errs = ar_error.try(:message) || {}
    add(msg)
    message
  end

end
