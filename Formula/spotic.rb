class Spotic < Formula
  desc "Spotify CLI controller"
  homepage "https://github.com/GHaxZ/spotic/"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GHaxZ/spotic/releases/download/v0.1.1/spotic-aarch64-apple-darwin.tar.xz"
      sha256 "9a7f0ad304d1900be836ef4c38a5cc58fc111b54eb21c8d86a5c0a087d968a63"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GHaxZ/spotic/releases/download/v0.1.1/spotic-x86_64-apple-darwin.tar.xz"
      sha256 "28c6666fc2fe032aeb072e9e02f4d96068f3efcacc4c70f26b1c4edf9251da13"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/GHaxZ/spotic/releases/download/v0.1.1/spotic-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "945db7802a756381a7f2b48f08753c97a476932f272bea0ae63bb43336e81e11"
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
