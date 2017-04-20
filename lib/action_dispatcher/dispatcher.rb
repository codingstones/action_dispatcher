module ActionDispatcher
  class Dispatcher
    def initialize
      @actions = {}
    end

    def add_action(action_name, action)
      @actions[action_name] = action
    end

    def execute(action_name, parameters=nil)
      action = @actions[action_name]

      raise ActionNotFoundError if action.nil?
      raise ArgumentError unless has_same_number_of_parameters?(action, parameters)

      action.execute(*parameters)
    end

    private

    def has_same_number_of_parameters?(action, parameters)
      action.public_method(:execute).parameters.length == parameters_length(parameters)
    end

    def parameters_length(parameters)
      return 0 if parameters.nil?

      parameters.length
    end
  end

  class ActionNotFoundError < StandardError
  end

  class ArgumentError < StandardError
  end
end