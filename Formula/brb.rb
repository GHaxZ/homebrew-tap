class Brb < Formula
  desc "Terminal be right back tool"
  homepage "https://github.com/GHaxZ/brb/"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GHaxZ/brb/releases/download/v0.1.2/brb-aarch64-apple-darwin.tar.xz"
      sha256 "31f8aa60d73351caa90a6ef3a9dee87a7ea161d3f3c058eb26e58582feb522fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GHaxZ/brb/releases/download/v0.1.2/brb-x86_64-apple-darwin.tar.xz"
      sha256 "c84e0fb541d4e52d2ae9f9b8b7d612944390016d5bc40517d07d9f7d34eb8f0f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/GHaxZ/brb/releases/download/v0.1.2/brb-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "7abb42a9f3d52b983d9096bf13a9411d25b7df891bc25c60173e8ec7635eb806"
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
