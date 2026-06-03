class Easy8McpServer < Formula
  desc "MCP server for the Easy8 API using JSON-RPC over stdio"
  homepage "https://github.com/bighub-ai/easy8-mcp"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.2.0/easyproject-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "5ac508952ba74653189511f9b378b0c30300df0512fe32b2468295728a22e0e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.2.0/easyproject-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "755e06cd48d5fd59c2fa79230bd16eccc11c8601b0af607af90965968f51fff3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.2.0/easyproject-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "65de37e2dbd975d332731fc22c0c3337eb8a5a705fe49da33cdc6407cb73ec23"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.2.0/easyproject-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6f98d0500601337ce8f8751fb57f65dc2f99a6c4da32fd35d1ff84c3426c3e01"
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
