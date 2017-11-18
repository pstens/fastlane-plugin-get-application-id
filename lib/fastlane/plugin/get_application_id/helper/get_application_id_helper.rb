module Fastlane
  module Helper
    class GetApplicationIdHelper
      # class methods that you define here become available in your action
      # as `Helper::GetApplicationIdHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the get_application_id plugin helper!")
      end
    end
  end
end
