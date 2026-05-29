class EasyprojectMcpServer < Formula
  desc "A Rust MCP server for the EasyProject API using JSON-RPC over stdio"
  homepage "https://github.com/bighub-ai/easy8-mcp"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.1.1/easyproject-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "708a5be156acb78e59376dfac052738779f8ee881e71dca3d22820f18f2002fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.1.1/easyproject-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "d1699778743c71b486cd214965284773a84c532482a0dfe6f3e19c688ef4fdf3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.1.1/easyproject-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7773201a14325f4575e24f2e40c12775e52c171e43423faef7703cd438e8291a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.1.1/easyproject-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6386fca190345aaca0427233a6d834b1073e1d7e4b7957614ba6afb1cb2b30ea"
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

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
