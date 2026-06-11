class Easy8McpServer < Formula
  desc "MCP server for the Easy8 API using JSON-RPC over stdio"
  homepage "https://github.com/bighub-ai/easy8-mcp"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.3.0/easy8-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "c95555d0096b8d249213685479456aa1432717406274583f76779551bec93d61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.3.0/easy8-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "94f2aca7593fe5a29e9f1e8bea051901b25e988bc05fd89ba133e0e09cba7dc2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.3.0/easy8-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b4f1e69855fbb6e2d0ede5a3ccf5d874c8c9a3a9b5e23282c9c00b24ee8e2439"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp/releases/download/v0.3.0/easy8-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1c0faa9ab17dd93ce756c559adbdb7872864dc1bd239f55a59725d1e41cc4b67"
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
