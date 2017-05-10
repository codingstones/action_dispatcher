describe ActionDispatcher::Dispatcher do
  let(:action_name) { :add }

  before(:each) do
    @dispatcher = ActionDispatcher::Dispatcher.new
  end

  context "when validating actions" do
    it "executes validate method" do
      @dispatcher.add_action(action_name, ReturnParamsObjectAction.new)

      params = @dispatcher.execute(action_name, { operand_not_nil: nil, operand2: 2 })

      expect(params.notification).to have_errors
      expect(params.notification.errors[0]).to eq("operand_not_nil is nil")
    end
  end

  context "when executing actions" do
    it "executes chosen action with its parameters" do
      @dispatcher.add_action(action_name, AdderAction.new)

      result = @dispatcher.execute(action_name, { operand1: 1, operand2: 2 })

      expect(result).to eq(3)
    end

    context "when action does not have any parameters" do
      it "executes the action without any parameters" do
        @dispatcher.add_action(:without_parameters, ActionWithoutParameters.new)

        result = @dispatcher.execute(:without_parameters)

        expect(result).to eq(ActionWithoutParameters::RESULT)
      end
    end

    context "when action has different number of parameters" do
      it "executes action with parameters" do
        @dispatcher.add_action(action_name, AdderAction.new)

        result = @dispatcher.execute(action_name, { operand1: 1 , operand2: 2, operand3: 3})

        expect(result).to eq(3)
      end
    end

    context "when action has keyword parameters" do
      it "executes action with parameters" do
        @dispatcher.add_action(action_name, AdderActionWithKeywordParameters.new)

        result = @dispatcher.execute(action_name, { operand1: 1, operand2: 2 })

        expect(result).to eq(3)
      end
    end

    context "when action is not found" do
      it "raises an error" do
        expect { @dispatcher.execute(:non_existent, []) }.to \
          raise_error(ActionDispatcher::ActionNotFoundError)
      end
    end
  end

  context "when adding an action" do
    it "adds the action to dispatcher" do
      @dispatcher.add_action(action_name, AdderAction.new)

      expect(@dispatcher).to include(action_name)
    end
    context "and has been already added" do
      it "raises an error" do
        @dispatcher.add_action(action_name, AdderAction.new)

        expect { @dispatcher.add_action(action_name, AdderAction.new) }.to \
          raise_error(ActionDispatcher::ActionAlreadyExistsError)
      end
    end
  end
end

class AdderAction
  def execute(params)
    params[:operand1] + params[:operand2]
  end
end

class ReturnParamsObjectAction
  def validate(params)
    params.notification << "operand_not_nil is nil" if params[:operand_not_nil].nil?
  end

  def execute(params)
    params
  end
end

class AdderActionWithKeywordParameters
  def execute(operand1:, operand2:)
    operand1 + operand2
  end
end

class ActionWithoutParameters
  RESULT = 'a result'

  def execute
    RESULT
  end
end
