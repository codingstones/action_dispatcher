module ActionDispatcher
  class Dispatcher
    def initialize
      @actions = {}
    end

    def add_action(action_name, action)
      raise ActionAlreadyExistsError if @actions.include? action_name
      @actions[action_name] = action
    end

    def execute(action_name, parameters=nil)
      action = @actions[action_name]

      raise ActionNotFoundError if action.nil?
      raise ArgumentError unless has_same_number_of_parameters?(action, parameters)

      action.execute(*map_parameters_to_action_parameters(action, parameters))
    end

    private

    def has_same_number_of_parameters?(action, parameters)
      parameters_for_action(action).length == parameters_length(parameters)
    end

    def parameters_for_action(action)
      action.public_method(:execute).parameters
    end

    def parameters_length(parameters)
      return 0 if parameters.nil?

      parameters.length
    end

    def map_parameters_to_action_parameters(action, parameters)
      return parameters if parameters.is_a?(Array)

      if parameters.is_a?(Hash)
        parameters_for_action(action).map do |parameter|
          parameters[parameter[1]]
        end
      end
    end
  end
end
