class Easy8McpServer < Formula
  desc "MCP server for the Easy8 API using JSON-RPC over stdio"
  homepage "https://github.com/bighub-ai/easy8-mcp"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.3.1/easy8-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "b6929664066e6f2afd671bfef3f30525d5db190ef40aaf6aa73b7e871a74155a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.3.1/easy8-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "1283bb0bc8ee6789e01501f8f5d9a94b99c42953b143ba1ff85dd345b1d4fc43"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.3.1/easy8-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2fb8a02a3c8f024130428ba4b4dbb7e48761119bf1ce3d74c200d72e04201c3f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.3.1/easy8-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "14abfa797f30d605ce3b9a20ea8315c10171ac98ab720c76bb9af96fd1f78e9c"
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
