class Snow < Formula
  desc "A winter landscape in your terminal"
  homepage "https://github.com/GHaxZ/snow/"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GHaxZ/snow/releases/download/v0.1.0/snow-aarch64-apple-darwin.tar.xz"
      sha256 "7e4deed934e74e8de05f1db84283646d61fc640bf7250557610e0f81e43cff3e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GHaxZ/snow/releases/download/v0.1.0/snow-x86_64-apple-darwin.tar.xz"
      sha256 "808b0173e0f7c037dd2ed6337ad4489003de55c03ca34e5f2a4cb508c7f711e2"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/GHaxZ/snow/releases/download/v0.1.0/snow-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5f361aa5e980b15cd68b144d4ed381ad44ead96d7d2badfd00902c0a7c65cb5d"
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
    bin.install "snow" if OS.mac? && Hardware::CPU.arm?
    bin.install "snow" if OS.mac? && Hardware::CPU.intel?
    bin.install "snow" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
