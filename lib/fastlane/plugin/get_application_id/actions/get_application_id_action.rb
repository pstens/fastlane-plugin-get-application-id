module Fastlane
  module Actions
    class GetApplicationIdAction < Action
      def self.run(params)
        application_id = nil
          constant_name ||= params[:ext_constant_name]
          gradle_file_path ||= params[:gradle_file_path]
          if gradle_file_path != nil
              UI.message("The get_application_id plugin will use gradle file at (#{gradle_file_path})!")
              application_id = getApplicationId(gradle_file_path, constant_name)
          else
              app_folder_name ||= params[:app_folder_name]
              UI.message("The get_application_id plugin is looking inside your project folder (#{app_folder_name})!")

              Dir.glob("**/#{app_folder_name}/build.gradle") do |path|
                  UI.message(" -> Found a build.gradle file at path: (#{path})!")
                  application_id = getApplicationId(path, constant_name)
              end
          end

          if applicationId.nil?
              UI.user_error!("Impossible to find the applicationId with the specified properties 😭")
          else
              # Store the applicationId in the shared hash
              Actions.lane_context["APPLICATION_ID"]= applicationId
              UI.success("👍 applicationId found: #{applicationId}")
          end

          return applicationId
      end

      def self.getApplicationId(path, constant_name)
          applicationId = nil
          if !File.file?(path)
              UI.message(" -> No file exists at path: (#{path})!")
              return applicationId
          end
          begin
              file = File.new(path, "r")
              while (line = file.gets)
                  if line.include? constant_name
                     components = line.strip.split(' ')
                     applicationId = components[components.length - 1].tr("\"","")
                     break
                  end
              end
              file.close
          rescue => err
              UI.error("An exception occured while reading the gradle file: #{err}")
              err
          end
          return applicationId
      end

      def self.description
        "Get the applicationId of an Android project."
      end

      def self.authors
        ["Helder Pinhal"]
      end

      def self.return_value
        "Returns the applicationId."
      end

      def self.details
        "Get the applicationId of an Android project. This action will return the applicationId of your project according to the one set in your build.gradle file."
      end

      def self.available_options
        [
            FastlaneCore::ConfigItem.new(key: :app_folder_name,
                                    env_name: "GETAPPLICATIONID_APP_NAME",
                                 description: "The name of the application source folder in the Android project (default: app)",
                                    optional: true,
                                        type: String,
                               default_value:"app"),
            FastlaneCore::ConfigItem.new(key: :gradle_file_path,
                                    env_name: "GETAPPLICATIONID_GRADLE_FILE_PATH",
                                 description: "The relative path to the gradle file containing the applicationId parameter (default:app/build.gradle)",
                                    optional: true,
                                        type: String,
                               default_value: nil),
             FastlaneCore::ConfigItem.new(key: :ext_constant_name,
                                     env_name: "GETAPPLICATIONID_EXT_CONSTANT_NAME",
                                  description: "If the applicationId is set in an ext constant, specify the constant name (optional)",
                                     optional: true,
                                         type: String,
                                default_value: "applicationId")
          ]
      end

      def self.output
          [
            ['APPLICATION_ID', 'The applicationId']
          ]
        end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end
