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
    File.open(manifest_path, "w") do |file|
      manifest.to_json(file)
    end
    Log.info &.emit(
      "Manifest installed",
      manifest_path: manifest_path.to_s
    )
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
  end
end
