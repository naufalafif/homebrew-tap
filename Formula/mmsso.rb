class Mmsso < Formula
  desc "Use mmctl with SSO — no Personal Access Token needed"
  homepage "https://github.com/naufalafif/mmsso"
  url "https://github.com/naufalafif/mmsso/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "cc58c367921d3247de63ca9e05a1b0e46c40c44c8e13f8621ca2ba612124f5b3"
  license "MIT"

  depends_on :macos
  depends_on "mmctl" => :recommended

  def install
    system "swiftc", "-O", "-o", "cookie-reader", "cookie-reader.swift", "-lsqlite3"
    system "codesign", "-s", "-", "-i", "com.naufalafif.mmsso.cookie-reader", "cookie-reader"

    bin.install "cookie-reader"
    bin.install "mmsso"
    bin.install "refresh-token.py"
  end

  test do
    assert_match "mmsso", shell_output("#{bin}/mmsso help")
    assert_match "Usage:", shell_output("#{bin}/cookie-reader 2>&1", 1)
  end
end
