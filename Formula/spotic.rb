class Spotic < Formula
  desc "Spotify CLI controller"
  homepage "https://github.com/GHaxZ/spotic/"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GHaxZ/spotic/releases/download/v0.1.0/spotic-aarch64-apple-darwin.tar.xz"
      sha256 "6e1995b171b2b2c5796f49ccc8d216653d9b92f2693e5cf31dbb00d93f70da1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GHaxZ/spotic/releases/download/v0.1.0/spotic-x86_64-apple-darwin.tar.xz"
      sha256 "e2d8c6aad00c54949dcab22d4844aa0c2ca15bd35d3b2a1610182f3d33294905"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/GHaxZ/spotic/releases/download/v0.1.0/spotic-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b8ea52399d219aceaccb4c099a5314a8b41dacee6154f9b8aaeb7809c4f920f7"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "sc" if OS.mac? && Hardware::CPU.arm?
    bin.install "sc" if OS.mac? && Hardware::CPU.intel?
    bin.install "sc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
