class Brb < Formula
  desc "Terminal be right back tool"
  homepage "https://github.com/GHaxZ/brb/"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GHaxZ/brb/releases/download/v0.1.1/brb-aarch64-apple-darwin.tar.xz"
      sha256 "54bbb2cfe28679bac5ae7cdc2dfe22ae4c6cf954029b0646ebd4a2e2c9232150"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GHaxZ/brb/releases/download/v0.1.1/brb-x86_64-apple-darwin.tar.xz"
      sha256 "4216292577c7b7b140e00ecbf730b10dd1a76eb1e2e085680cf5f2bea0417995"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/GHaxZ/brb/releases/download/v0.1.1/brb-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "82257b940cc616aad775ec3b852f3a9d22eead3bf9dbf9387ea5dbe6eed633b1"
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
