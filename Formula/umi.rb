class Umi < Formula
  desc "UMI device management tool."
  homepage "https://umi.engineering/cli"
  version "0.0.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umi-eng/cli/releases/download/v0.0.7/umi-aarch64-apple-darwin.tar.xz"
      sha256 "f79fb784258566d13e785f448844fc38e00525f93957ae46697554404ff067d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umi-eng/cli/releases/download/v0.0.7/umi-x86_64-apple-darwin.tar.xz"
      sha256 "fead2d76b18b2a3e99abd70594242b11c1c99e4bc1bf9d2ad994ef5540ad5c6a"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/umi-eng/cli/releases/download/v0.0.7/umi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "891a974cb69df3b03876cc6147651aee705cb40d2419555406d53f348cccc08f"
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
