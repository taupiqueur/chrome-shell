require "./env"

# Enum representing a platform.
enum Platform
  Chrome
  ChromeDev
  ChromeBeta
  ChromeCanary
  Chromium

  # Maps a given platform to its user data directory.
  # Reference: https://chromium.googlesource.com/chromium/src/+/main/docs/user_data_dir.md
  def user_data_dir : Path
    case self
    in .chrome?
      CHROME_USER_DATA_DIR
    in .chrome_dev?
      CHROME_DEV_USER_DATA_DIR
    in .chrome_beta?
      CHROME_BETA_USER_DATA_DIR
    in .chrome_canary?
      CHROME_CANARY_USER_DATA_DIR
    in .chromium?
      CHROMIUM_USER_DATA_DIR
    end
  end

  # Returns the native manifest directory.
  # Reference: https://developer.chrome.com/docs/extensions/mv3/nativeMessaging/#native-messaging-host-location
  def native_manifest_dir : Path
    user_data_dir / "NativeMessagingHosts"
  end
end

# The default location of the user data directory for each platform.
# Reference: https://chromium.googlesource.com/chromium/src/+/main/docs/user_data_dir.md
{% if flag?(:darwin) %}
  CHROME_CONFIG_HOME = Path.home / "Library" / "Application Support"
  CHROME_USER_DATA_DIR = CHROME_CONFIG_HOME / "Google" / "Chrome"
  CHROME_DEV_USER_DATA_DIR = CHROME_CONFIG_HOME / "Google" / "Chrome Dev"
  CHROME_BETA_USER_DATA_DIR = CHROME_CONFIG_HOME / "Google" / "Chrome Beta"
  CHROME_CANARY_USER_DATA_DIR = CHROME_CONFIG_HOME / "Google" / "Chrome Canary"
  CHROMIUM_USER_DATA_DIR = CHROME_CONFIG_HOME / "Chromium"
{% elsif flag?(:unix) %}
  CHROME_CONFIG_HOME = Path[ENV["XDG_CONFIG_HOME"]]
  CHROME_USER_DATA_DIR = CHROME_CONFIG_HOME / "google-chrome"
  CHROME_DEV_USER_DATA_DIR = CHROME_CONFIG_HOME / "google-chrome-dev"
  CHROME_BETA_USER_DATA_DIR = CHROME_CONFIG_HOME / "google-chrome-beta"
  CHROME_CANARY_USER_DATA_DIR = CHROME_CONFIG_HOME / "google-chrome-canary"
  CHROMIUM_USER_DATA_DIR = CHROME_CONFIG_HOME / "chromium"
{% elsif flag?(:windows) %}
  CHROME_CONFIG_HOME = Path[ENV["LOCALAPPDATA"]]
  CHROME_USER_DATA_DIR = CHROME_CONFIG_HOME / "Google" / "Chrome" / "User Data"
  CHROME_DEV_USER_DATA_DIR = CHROME_CONFIG_HOME / "Google" / "Chrome Dev" / "User Data"
  CHROME_BETA_USER_DATA_DIR = CHROME_CONFIG_HOME / "Google" / "Chrome Beta" / "User Data"
  CHROME_CANARY_USER_DATA_DIR = CHROME_CONFIG_HOME / "Google" / "Chrome Canary" / "User Data"
  CHROMIUM_USER_DATA_DIR = CHROME_CONFIG_HOME / "Chromium" / "User Data"
{% else %}
  raise "Unsupported platform"
{% end %}
