class EasyprojectMcpServer < Formula
  desc "MCP server for the Easy8 API using JSON-RPC over stdio"
  homepage "https://github.com/bighub-ai/easy8-mcp"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.1.5/easyproject-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "c3c6248058648bebb1c65ad14fde0a632c6736d5285b398b252d98945876b675"
    generate_completions_from_executable(bin/"easyproject-mcp-server", shell_parameter_format: :clap)    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.1.5/easyproject-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "ad719c4f5b9297d0900f3cb012839a99e6553c501c04665ac5892eadde452adb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.1.5/easyproject-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "982a855768c85f9682260ad07f1d8a372957bf60212c820f60e9c85a7244d34d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bighub-ai/easy8-mcp-releases/releases/download/v0.1.5/easyproject-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "301ae6f956eff2637eaf90f5e5f4ebd5a22e8c30fe069041cdec731c10e8a0ea"
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
