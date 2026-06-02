class EasyprojectMcpServer < Formula
  desc "MCP server for the Easy8 API using JSON-RPC over stdio"
  homepage "https://github.com/bighub-ai/easy8-mcp"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.1.7/easyproject-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "791118ea3f99f9c15fc2fd5cbe5c459621e79305eb1006ad19d2640e65abcb2f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.1.7/easyproject-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "74d97f3e91447d708864a9b7ee0fabeff5878374dbd820efc8cb4c084a82deaa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.1.7/easyproject-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "344cdbbdc53632cdbd0feca46261a47a47a8013c9af15a68e6e907302f74a58e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.1.7/easyproject-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ae4a62d0cdd90fe57f7a351d317b608abdb701757fef89173f6b27da06e44477"
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
    generate_completions_from_executable(bin/"easyproject-mcp-server", shell_parameter_format: :clap)
  end
end
