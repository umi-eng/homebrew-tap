class Umi < Formula
  desc "UMI device management CLI tool"
  homepage "https://umi.engineering/cli"
  version "0.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umi-eng/cli/releases/download/v0.0.3/umi-aarch64-apple-darwin.tar.xz"
      sha256 "673840ec7ef11fe98ef1ce25cdacbe65709996a9a25632ec50f129e009329cd8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-eng/cli/releases/download/v0.0.3/umi-x86_64-apple-darwin.tar.xz"
      sha256 "6cbf752a5e92f081cc1b0c5f636a9350f4c4ee8cb7b852546aa3cdc9976a264e"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/umi-eng/cli/releases/download/v0.0.3/umi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e7ceea780c91c41671d263233ea170f3c7e2f0c2d5c4cf44596ffe4c5c54a858"
    end
  end
  license "MPL-2.0"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
      bin.install "umi"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "umi"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "umi"
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
