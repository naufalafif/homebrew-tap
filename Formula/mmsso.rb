class Mmsso < Formula
  desc "Use mmctl with SSO — no Personal Access Token needed"
  homepage "https://github.com/naufalafif/mmsso"
  url "https://github.com/naufalafif/mmsso/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "620ff5b9c56fdc316f228dfda25ba260284417f4619567feaca3bcc5902e2349"
  license "MIT"

  depends_on :macos
  depends_on "mmctl" => :recommended

  def install
    system "swiftc", "-O", "-o", "cookie-reader", "cookie-reader.swift", "-lsqlite3"
    system "codesign", "-s", "-", "-i", "com.naufalafif.mmsso.cookie-reader", "cookie-reader"

    bin.install "cookie-reader"
    bin.install "mmsso"
  end

  test do
    assert_match "mmsso", shell_output("#{bin}/mmsso help")
    assert_match "Usage:", shell_output("#{bin}/cookie-reader 2>&1", 1)
  end
end
