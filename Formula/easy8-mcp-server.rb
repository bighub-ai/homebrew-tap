class Easy8McpServer < Formula
  desc "MCP server for the Easy8 API using JSON-RPC over stdio"
  homepage "https://github.com/bighub-ai/easy8-mcp"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.2.1/easy8-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "ad815e066789190666dc8b112911fd03282db5e3a9f59aadde1e5335f76f530d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.2.1/easy8-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "9f8419b182f2715fa93af282b9d286467649bd7c598634a6044d3f0c082801bc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.2.1/easy8-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a356eda4948b078e686c8e4a35c42c82598860f40a5d63d2fa11394ebddb9d29"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.2.1/easy8-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5966bfb4c240a09e3101001f054dd87c58f6db91c0d38c91ef5b9ccb9c20e5d3"
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
