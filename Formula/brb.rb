class Brb < Formula
  desc "Terminal be right back tool"
  homepage "https://github.com/GHaxZ/brb/"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GHaxZ/brb/releases/download/v0.1.0/brb-aarch64-apple-darwin.tar.xz"
      sha256 "a6c34d7cd156f3da898a9334301f6c9149bc3ee745bbdecf3d7006c42fb7b6ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GHaxZ/brb/releases/download/v0.1.0/brb-x86_64-apple-darwin.tar.xz"
      sha256 "0324450b3cc5052203796a8d996e40f35b1fdd66762838ee83906390b03be3c5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/GHaxZ/brb/releases/download/v0.1.0/brb-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "98b71d69b5c4426e5a0f2fc308b637760b1c82e2b76e7042f9447c8c948d4026"
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
    bin.install "brb" if OS.mac? && Hardware::CPU.arm?
    bin.install "brb" if OS.mac? && Hardware::CPU.intel?
    bin.install "brb" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
