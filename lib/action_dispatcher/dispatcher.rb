# frozen_string_literal: true

module ActionDispatcher
  class Dispatcher
    def initialize
      @actions = {}
    end

    def add_action(action_name, action)
      raise ActionAlreadyExistsError if include?(action_name)
      @actions[action_name] = action
    end

    def include?(action_name)
      @actions.include?(action_name)
    end

    def execute(action_name, parameters = nil)
      action = @actions[action_name]

      raise ActionNotFoundError if action.nil?

      if not_parameters?(action)
        action.execute
      else
        raise ArgumentError if parameters.nil?
        action.execute(parameters)
      end
    end

    private

    def not_parameters?(action)
      action.public_method(:execute).parameters.empty?
    end
  end
end
