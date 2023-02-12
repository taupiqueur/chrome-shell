require "option_parser"

require "./manifest"
require "./platform"
require "./transport"
require "./command_processor"
require "./installer"

VERSION = {{ `git describe --tags --always`.chomp.stringify }}

enum Subcommand
  RunServer
  InstallManifest
  UninstallManifest
end

command = Subcommand::RunServer
manifest = Manifest.new("shell", "A native messaging host for executing shell commands.")
platform = Platform::Chrome

OptionParser.parse do |parser|
  parser.banner = "Usage: chrome-shell [options] [command]"
  parser.on("run", "Run server") do
    command = Subcommand::RunServer
    parser.banner = "Usage: chrome-shell run"
  end
  parser.on("install", "Install manifest and register specified extensions") do
    command = Subcommand::InstallManifest
    parser.banner = "Usage: chrome-shell install [extension-ids]"
    parser.unknown_args do |extension_ids|
      extension_ids.each do |extension_id|
        manifest.add_extension(extension_id)
      end
    end
  end
  parser.on("uninstall", "Uninstall manifest") do
    command = Subcommand::UninstallManifest
    parser.banner = "Usage: chrome-shell uninstall"
  end
  parser.on("--target=PLATFORM", "Specifies the target platform. Possible values: [chrome, chrome-dev, chrome-beta, chrome-canary, chromium]") do |platform_name|
    platform = case platform_name
    when "chrome"
      Platform::Chrome
    when "chrome-dev"
      Platform::ChromeDev
    when "chrome-beta"
      Platform::ChromeBeta
    when "chrome-canary"
      Platform::ChromeCanary
    when "chromium"
      Platform::Chromium
    else
      abort "ERROR: #{platform_name} is not a valid target."
    end
  end
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.on("-v", "--version", "Show version") do
    puts VERSION
    exit
  end
  parser.missing_option do |flag|
    abort "ERROR: #{flag} is missing something."
  end
  parser.invalid_option do |flag|
    abort "ERROR: #{flag} is not a valid option."
  end
end

case command
when .run_server?
  run_server(STDIN, STDOUT, STDERR)
when .install_manifest?
  install_manifest(manifest, platform)
when .uninstall_manifest?
  uninstall_manifest(manifest, platform)
end

def run_server(input : IO = STDIN, output : IO = STDOUT, error : IO = STDERR)
  input_stream = Channel(Command).new
  output_stream = Channel(CommandResult).new
  Transport.start(input_stream, output_stream)
  CommandProcessor.start(input_stream, output_stream)
  sleep
end

def install_manifest(manifest : Manifest, platform : Platform)
  installer = Installer.new(manifest, platform)
  installer.install_manifest
  puts "'#{installer.manifest_path}' written"
end

def uninstall_manifest(manifest : Manifest, platform : Platform)
  installer = Installer.new(manifest, platform)
  installer.uninstall_manifest
  puts "'#{installer.manifest_path}' deleted"
end
