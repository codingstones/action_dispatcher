module ActionDispatcher
  class Params < Hash
    def has_errors?
      not errors.empty?
    end

    def add_error(error)
      errors << error
    end

    def errors
      @errors ||= []
    end
  end
end
