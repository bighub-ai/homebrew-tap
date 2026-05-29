class EasyprojectMcpServer < Formula
  desc "A Rust MCP server for the EasyProject API using JSON-RPC over stdio"
  homepage "https://github.com/bighub-ai/easyproject-mcp-server"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easyproject-mcp-server/releases/download/v0.1.0/easyproject-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "328058116ae6b3089fc7eb98714958e4945b782e984dbaa643272ebde121c344"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easyproject-mcp-server/releases/download/v0.1.0/easyproject-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "4e4974211dd2347f9f9427e66405ceab420972513cfca7171b223ae6de5902c8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easyproject-mcp-server/releases/download/v0.1.0/easyproject-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e8053534e9a1f7675f0a931b4bb9ab7418b5426de9a1929bba87a5422341658a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easyproject-mcp-server/releases/download/v0.1.0/easyproject-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "40bc34b6d892676a0e51c3ffd549508516286998c179da3e82949589f7d65a81"
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
