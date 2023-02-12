# This class provides the functionality to transport messages over stdio.
# Native messaging protocol: https://developer.chrome.com/docs/apps/nativeMessaging/#native-messaging-host-protocol
class Transport
  # Creates a native messaging connection via stdio.
  def self.start(input_stream : Channel, output_stream : Channel)
    spawn receive(STDIN, input_stream)
    spawn send(output_stream, STDOUT)
  end

  # Reads messages.
  # Step 1: Read the message size (first 4 bytes).
  # Step 2: Read the text (JSON object) of the message.
  def self.receive(server_input : IO, input_stream : Channel(Message)) forall Message
    loop do
      bytes = server_input.read_bytes(Int32)
      sized_io = IO::Sized.new(server_input, read_size: bytes)
      message = Message.from_json(sized_io)
      input_stream.send(message)
    end
  end

  # Sends messages.
  # Step 1: Write the message size.
  # Step 2: Write the message itself.
  def self.send(output_stream : Channel(Message), server_output : IO) forall Message
    loop do
      message = output_stream.receive
      encoded_message = message.to_json
      encoded_size = encoded_message.bytesize
      server_output.write_bytes(encoded_size)
      server_output << encoded_message
      server_output.flush
    end
  end
end
