class Easy8McpServer < Formula
  desc "MCP server for the Easy8 API using JSON-RPC over stdio"
  homepage "https://github.com/bighub-ai/easy8-mcp"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.2.2/easy8-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "7041ef49a3198294ce041759eadc5a2f2156ac51c0c213c964cbc580e97dfe43"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.2.2/easy8-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "b46d641511637f3009607b52ffc47dee1d4283115a6354d24481fb7926ea7ffe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.2.2/easy8-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dec8c8e0f30923e996b825606e378a0a1cc83a2e141917ea02777e5ffce94c81"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.2.2/easy8-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "63be6ed114d13beee6d72efe542422978fd2a0abc2c3c84160ad43ea3c23d523"
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
    generate_completions_from_executable(bin/"easy8-mcp", shell_parameter_format: :clap)

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
