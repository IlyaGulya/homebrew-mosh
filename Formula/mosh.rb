class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/IlyaGulya/mosh/archive/1a1a028d653b8ffd77322629f171d944a215a5b2.tar.gz"
  sha256 "e84f42f5c1cc7927ea8ae5886ccdd80bfc5654cbd5af336c81f395f122bcdf32"
  license "GPL-3.0-or-later"
  revision 40

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
