class Easy8McpServer < Formula
  desc "MCP server for the Easy8 API using JSON-RPC over stdio"
  homepage "https://github.com/bighub-ai/easy8-mcp"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.3.2/easy8-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "e4f46c4eeefb5dc51a335cfd47d4e655ceb38f529fb9dd7659b67905ef8ba489"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.3.2/easy8-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "df6dca0d1e4a3991e4ad33a87bd99ee48f6478923b2149c8b7b9b8f7512043d3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.3.2/easy8-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b17069dad771e1a69bf7fc7d069e15ed0bcf2a4b4ff1b1db741cbbd251c86f86"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.3.2/easy8-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a285d2cd290e1e6f3e96b7d5b89b1e302bd2287e6207e45373189602cb585e6"
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
    bin.install "easy8-mcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "easy8-mcp" if OS.mac? && Hardware::CPU.intel?
    bin.install "easy8-mcp" if OS.linux? && Hardware::CPU.arm?
    bin.install "easy8-mcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
