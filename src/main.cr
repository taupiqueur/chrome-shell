require "option_parser"
require "log"

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
verbosity = 0
log_file = STDERR

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
  parser.on("-v", "Increases the level of verbosity (the max level is -vvv)") do
    verbosity += 1
  end
  parser.on("--log=FILE", "Specifies the file to use for logging") do |file|
    log_file = File.new(file, "a")
  end
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.on("-V", "--version", "Show version") do
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

log_level = case verbosity
when 0
  Log::Severity::Warn
when 1
  Log::Severity::Info
when 2
  Log::Severity::Debug
else
  Log::Severity::Trace
end

Log.setup(log_level, Log::IOBackend.new(log_file))

case command
when .run_server?
  run_server(ARGV, STDIN, STDOUT, STDERR)
when .install_manifest?
  install_manifest(manifest, platform)
when .uninstall_manifest?
  uninstall_manifest(manifest, platform)
end

def run_server(args : Array(String) = ARGV, input : IO = STDIN, output : IO = STDOUT, error : IO = STDERR)
  input_stream = Channel(Command).new
  output_stream = Channel(CommandResult).new
  Transport.start(input_stream, output_stream)
  CommandProcessor.start(input_stream, output_stream)
  Log.info &.emit(
    "chrome-shell started",
    allowed_origins: args
  )
  sleep
end

def install_manifest(manifest : Manifest, platform : Platform)
  installer = Installer.new(manifest, platform)
  installer.install_manifest
end

def uninstall_manifest(manifest : Manifest, platform : Platform)
  installer = Installer.new(manifest, platform)
  installer.uninstall_manifest
end
