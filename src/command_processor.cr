require "json"

abstract struct CommandMessage
  include JSON::Serializable
end

record Command < CommandMessage,
  # The command name.
  command : String,
  # The list of arguments passed to the command.
  args : Array(String) = [] of String,
  # The list of environment variables passed to the command.
  env : Hash(String, String | Nil) = {} of String => String | Nil,
  # Configures stdin data.
  input : String | Nil = nil,
  # Captures stdout stream.
  output : Bool = false,
  # Captures stderr stream.
  error : Bool = false,
  # Sets the working directory for the child process.
  dir : String | Nil = nil

record CommandResult < CommandMessage,
  # The exit code of the process.
  status : Int32,
  # Captured stdout stream.
  output : String,
  # Captured stderr stream.
  error : String

class CommandProcessor
  # Starts processing commands.
  def self.start(input_stream : Channel(Command), output_stream : Channel(CommandResult))
    spawn process(input_stream, output_stream)
  end

  def self.process(input_stream : Channel(Command), output_stream : Channel(CommandResult))
    loop do
      command = input_stream.receive
      spawn(name: "command processor") do
        # Standard streams
        stdin = IO::Memory.new
        stdout = IO::Memory.new
        stderr = IO::Memory.new

        if text_input = command.input
          stdin << text_input
          stdin.rewind
        end

        command_status = Process.run(
          command.command,
          command.args,
          env: command.env,
          input: command.input ? stdin : Process::Redirect::Close,
          output: command.output ? stdout : Process::Redirect::Close,
          error: command.error ? stderr : Process::Redirect::Close,
          chdir: command.dir
        )

        # Send the result.
        output_stream.send(
          CommandResult.new(
            command_status.exit_code,
            stdout.to_s,
            stderr.to_s
          )
        )
      end
    end
  end
end
