class Umi < Formula
  desc "UMI device management tool."
  homepage "https://umi.engineering/cli"
  version "0.0.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umi-eng/cli/releases/download/v0.0.5/umi-aarch64-apple-darwin.tar.xz"
      sha256 "0838ad07fad4cfe8b9420a2e73c3fa3460ebb94a998853fa79ddd50ca2f9b961"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-eng/cli/releases/download/v0.0.5/umi-x86_64-apple-darwin.tar.xz"
      sha256 "bafb32af060d7165e40042393498a8276148daeab77621737519228a7b5d1bb1"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/umi-eng/cli/releases/download/v0.0.5/umi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3a7bf3ee4c96a612e0918bc39b573ea658b5ca0dc4fafe8bc84292452c85b686"
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
