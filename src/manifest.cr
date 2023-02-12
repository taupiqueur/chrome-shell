require "json"

# Struct representing a native manifest.
# Reference: https://developer.chrome.com/docs/apps/nativeMessaging/#native-messaging-host
struct Manifest
  include JSON::Serializable

  # The name of the native application.
  getter name : String

  # The description of the native application.
  getter description : String

  # The path to the native application.
  getter path : Path

  # The type of interface used to communicate with the native application.
  getter type : String

  # The list of extensions allowed to communicate with the native application.
  getter allowed_origins : Set(String)

  def initialize(
    @name : String = PROGRAM_NAME,
    @description : String = PROGRAM_NAME,
    @path : Path = Path[Process.executable_path.to_s],
    @type : String = "stdio",
    @allowed_origins : Set(String) = Set(String).new
  )
  end

  # Adds an extension to allowed origins.
  def add_extension(extension_id : String)
    @allowed_origins << "chrome-extension://#{extension_id}/"
  end

  # Removes an extension from allowed origins.
  def remove_extension(extension_id : String)
    @allowed_origins.delete("chrome-extension://#{extension_id}/")
  end
end
