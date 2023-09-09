require "./spec_helper"

process = Process.new(
  "bin/chrome-shell",
  input: :pipe,
  output: :pipe,
  error: :pipe
)

Spec.after_suite do
  process.terminate
end

describe "chrome-shell" do
  context "without output option set" do
    it "does not capture stdout stream" do
      write_message(%({"command":"echo","args":["Hello, World!"]}), process.input)
      read_message(process.output).should eq %({"status":0,"output":"","error":""})
    end
  end

  context "without error option set" do
    it "does not capture stderr stream" do
      write_message(%({"command":"sh","args":["-c","echo 'Hello, World!' >&2"]}), process.input)
      read_message(process.output).should eq %({"status":0,"output":"","error":""})
    end
  end

  context "with input option set" do
    it "configures stdin data" do
      write_message(%({"command":"cat","input":"Hello, World!","output":true}), process.input)
      read_message(process.output).should eq %({"status":0,"output":"Hello, World!","error":""})
    end
  end

  context "with output option set" do
    it "captures stdout stream" do
      write_message(%({"command":"echo","args":["Hello, World!"],"output":true}), process.input)
      read_message(process.output).should eq %({"status":0,"output":"Hello, World!\\n","error":""})
    end
  end

  context "with error option set" do
    it "captures stderr stream" do
      write_message(%({"command":"sh","args":["-c","echo 'Hello, World!' >&2"],"error":true}), process.input)
      read_message(process.output).should eq %({"status":0,"output":"","error":"Hello, World!\\n"})
    end
  end

  context "with env option set" do
    it "sets environment variables" do
      write_message(%({"command":"env","env":{"FOO":"BAR"},"output":true}), process.input)
      read_message(process.output).should match /\A{"status":0,"output":".*\\nFOO=BAR\\n.*","error":""}\z/
    end
  end

  context "with dir option set" do
    it "sets the working directory" do
      write_message(%({"command":"pwd","output":true,"dir":"/"}), process.input)
      read_message(process.output).should eq %({"status":0,"output":"/\\n","error":""})
    end
  end

  context "with non-zero exit code" do
    it "exits correctly" do
      write_message(%({"command":"false"}), process.input)
      read_message(process.output).should eq %({"status":1,"output":"","error":""})
    end
  end
end
