class Umi < Formula
  desc "UMI device management tool."
  homepage "https://umi.engineering/cli"
  version "0.0.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umi-eng/cli/releases/download/0.0.8/umi-aarch64-apple-darwin.tar.xz"
      sha256 "55a53ea466f554de20b872e1f1c658671f3ad19823c64b320a07ca08330ca7db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-eng/cli/releases/download/0.0.8/umi-x86_64-apple-darwin.tar.xz"
      sha256 "05ffec0294ce7204595fc1fb0c02175d52301d7f781c643e81c2942d42b4776a"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/umi-eng/cli/releases/download/0.0.8/umi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bf95838a9cfc7784403ee37e74d0a41d8eee0442c0eaae7551adb9fe4fb4d503"
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
