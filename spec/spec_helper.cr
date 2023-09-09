require "spec"

def read_message(io : IO)
  bytes = io.read_bytes(Int32)
  io.read_string(bytes)
end

def write_message(message : String, io : IO)
  io.write_bytes(message.bytesize)
  io << message
  io.flush
end
