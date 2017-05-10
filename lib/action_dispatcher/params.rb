module ActionDispatcher
  class Params < Hash
    def notification
      @notification ||= Notification.new
    end
  end

  class Notification
    attr_reader :errors

    def initialize
      @errors = []
    end

    def <<(error)
      @errors << error
    end

    def has_errors?
      not @errors.empty?
    end
  end
end
