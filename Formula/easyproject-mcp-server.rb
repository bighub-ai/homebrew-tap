class EasyprojectMcpServer < Formula
  desc "MCP server for the Easy8 API using JSON-RPC over stdio"
  homepage "https://github.com/bighub-ai/easy8-mcp"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.1.8/easyproject-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "17bad32c71156d9905aa16c6aba7e7cbf8a49492c429489b339dc241c5468cc8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.1.8/easyproject-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "19135d5866f9b64f68e23f8265aa4c2d5958e970a98928cb4ee13b690b15c738"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.1.8/easyproject-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "161db990ee65b051629f15617662f706b2592924fc7db7fc2b2c49513b88dbdc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.1.8/easyproject-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8fde2e6711f2488eacebf1b747767ccc356b086f56852863e230175f2be912b3"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "easyproject-mcp-server" if OS.mac? && Hardware::CPU.arm?
    bin.install "easyproject-mcp-server" if OS.mac? && Hardware::CPU.intel?
    bin.install "easyproject-mcp-server" if OS.linux? && Hardware::CPU.arm?
    bin.install "easyproject-mcp-server" if OS.linux? && Hardware::CPU.intel?
    generate_completions_from_executable(bin/"easyproject-mcp-server", shell_parameter_format: :clap)

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
