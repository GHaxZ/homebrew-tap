class Brb < Formula
  desc "Terminal be right back tool"
  homepage "https://github.com/GHaxZ/brb/"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GHaxZ/brb/releases/download/v0.1.3/brb-aarch64-apple-darwin.tar.xz"
      sha256 "5f3486cf92901be3a71eb023756d981e3ce7c0756b40bc6082ff5637538f8b53"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GHaxZ/brb/releases/download/v0.1.3/brb-x86_64-apple-darwin.tar.xz"
      sha256 "4f16d16239aa1ea107783ddf228fa0ceb80b513ecb183f07551cd21710897ad8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/GHaxZ/brb/releases/download/v0.1.3/brb-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "03a34b1626ff879545406baefb9799a511828661b37d91c44a0a46cd8b501452"
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
