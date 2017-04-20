describe ActionDispatcher::Dispatcher do
  let(:action_name) { :add }

  before(:each) do
    @dispatcher = ActionDispatcher::Dispatcher.new
  end

  it "executes chosen action with its parameters" do
    @dispatcher.add_action(action_name, AdderAction.new)

    result = @dispatcher.execute(action_name, [1, 2])

    expect(result).to eq(3)
  end

  context "when action is not found" do
    it "raises an error" do
      expect { @dispatcher.execute(:non_existent, []) }.to \
        raise_error(ActionDispatcher::ActionNotFoundError)
    end
  end
end

class AdderAction
  def execute(operand1, operand2)
    operand1 + operand2
  end
end