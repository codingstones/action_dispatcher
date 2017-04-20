module ActionDispatcher
  class Dispatcher
    def initialize
      @actions = {}
    end

    def add_action(action_name, action)
      @actions[action_name] = action
    end

    def execute(action_name, parameters=nil)
      if @actions[action_name]
        @actions[action_name].execute(*parameters)
      else
        raise ActionNotFoundError
      end
    end
  end

  class ActionNotFoundError < StandardError
  end
end