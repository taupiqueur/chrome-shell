require "./manifest"
require "./platform"

class Installer
  # The native manifest to install.
  getter manifest : Manifest

  # The target platform.
  property platform : Platform

  def initialize(@manifest : Manifest = Manifest.new, @platform : Platform = :chrome)
  end

  def manifest_path : Path
    platform.native_manifest_dir / "#{manifest.name}.json"
  end

  def install_manifest(manifest_path : Path = manifest_path)
    if File.exists?(manifest_path)
      merge_manifest(manifest_path)
    end
    Dir.mkdir_p(manifest_path.parent)
    File.open(manifest_path, "w") do |file|
      manifest.to_json(file)
    end
    Log.info &.emit(
      "Manifest installed",
      manifest_path: manifest_path.to_s
    )

    {% if flag?(:windows) %}
      reg_add(reg_key, manifest_path.to_s)
    {% end %}
  end

  def merge_manifest(manifest_path : Path = manifest_path)
    other_manifest = File.open(manifest_path) do |file|
      Manifest.from_json(file)
    end
    manifest.allowed_origins.concat(other_manifest.allowed_origins)
  end

  def uninstall_manifest(manifest_path : Path = manifest_path)
    File.delete(manifest_path)
    Log.info &.emit(
      "Manifest uninstalled",
      manifest_path: manifest_path.to_s
    )

    {% if flag?(:windows) %}
      reg_delete(reg_key)
    {% end %}
  end

  # Adds a new entry to the Windows registry.
  # Reference: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/reg-add
  private def reg_add(key : String, value : String)
    command_status = Process.run(
      "REG",
      {"ADD", key, "/ve", "/t", "REG_SZ", "/d", value, "/f"}
    )
    unless command_status.success?
      raise RuntimeError.new
    end
    Log.info &.emit(
      "Registry entry added",
      key: key,
      value: value
    )
  end

  # Deletes specified entry from the Windows registry.
  # Reference: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/reg-delete
  private def reg_delete(key : String)
    command_status = Process.run(
      "REG",
      {"DELETE", key, "/f"}
    )
    unless command_status.success?
      raise RuntimeError.new
    end
    Log.info &.emit(
      "Registry entry deleted",
      key: key
    )
  end

  # Returns the native app’s registry key.
  # Reference: https://developer.chrome.com/docs/extensions/mv3/nativeMessaging/#native-messaging-host-location
  private def reg_key : String
    case platform
    in .chrome?
      "HKCU\\Software\\Google\\Chrome\\NativeMessagingHosts\\#{manifest.name}"
    in .chrome_dev?
      "HKCU\\Software\\Google\\Chrome Dev\\NativeMessagingHosts\\#{manifest.name}"
    in .chrome_beta?
      "HKCU\\Software\\Google\\Chrome Beta\\NativeMessagingHosts\\#{manifest.name}"
    in .chrome_canary?
      "HKCU\\Software\\Google\\Chrome Canary\\NativeMessagingHosts\\#{manifest.name}"
    in .chromium?
      "HKCU\\Software\\Chromium\\NativeMessagingHosts\\#{manifest.name}"
    end
  end
end
