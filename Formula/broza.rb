class Broza < Formula
  desc "Broza: safe disk cleanup CLI for macOS"
  homepage "https://github.com/borlafu/broza"
  version "1.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/borlafu/broza/releases/download/v1.1.0/broza-cli-aarch64-apple-darwin.tar.xz"
    sha256 "5ca0028c7d300021750bfeabea8224402684d73e598e5b69ec4087f699d3adee"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "broza"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
