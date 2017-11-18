describe Fastlane::Actions::GetApplicationIdAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The get_application_id plugin is working!")

      Fastlane::Actions::GetApplicationIdAction.run(nil)
    end
  end
end
