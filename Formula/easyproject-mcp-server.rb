class EasyprojectMcpServer < Formula
  desc "MCP server for the Easy8 API using JSON-RPC over stdio"
  homepage "https://github.com/bighub-ai/easy8-mcp"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.1.6/easyproject-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "2f8f59a6b54abf3f5cce4c96fc4b83fc4f6005b9471e58b130c6cd0e700e0355"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.1.6/easyproject-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "3920e71183ff8eb5a2c7900f4829f6e98a39a3214029dfe9e016a5605c1f6a22"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.1.6/easyproject-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f8f039cab51efeb10b129d40e6f6ab888c967fe847fd5bf303e803ce046be149"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.1.6/easyproject-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "74cfba830cc3734930496fe4bab3d94c2574b33c922e7622bc0e0c1c9173d8bd"
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
