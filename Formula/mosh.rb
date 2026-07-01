class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/IlyaGulya/mosh/archive/dfb9fc54dd20e62b9181acbc25b6ca9cd8bbd75b.tar.gz"
  version "1.4.0"
  sha256 "760e50501809bd31a8d1590ad79848889e7bf6af6f0cb9b7c4ce4ea598832faa"
  license "GPL-3.0-or-later"
  revision 41

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "tmux" => :build
  end

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.append_to_cflags "-DNDEBUG"
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?
    ENV.append "CXXFLAGS", "-std=gnu++17"

    inreplace "scripts/mosh.pl", "'mosh-client", "'#{bin}/mosh-client"
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--enable-completion", "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
