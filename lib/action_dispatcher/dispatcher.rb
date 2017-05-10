module ActionDispatcher
  class Dispatcher
    def initialize
      @actions = {}
    end

    def add_action(action_name, action)
      raise ActionAlreadyExistsError if @actions.include? action_name
      @actions[action_name] = action
    end

    def include?(action_name)
      @actions.include?(action_name)
    end

    def execute(action_name, parameters=nil)
      action = @actions[action_name]

      raise ActionNotFoundError if action.nil?

      if parameters.nil?
        action.execute
      else
        action.execute(parameters)
      end
    end
  end
end
