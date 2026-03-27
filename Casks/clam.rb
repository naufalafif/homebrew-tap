cask "clam" do
  version "1.0.0"
  sha256 "9d91bf5c68d1de9910bd52327bd13c9822e8d864d518f4e424bf8a12c0c493ef"

  url "https://github.com/naufalafif/clam/releases/download/v#{version}/Clam.zip"
  name "Clam"
  desc "Claude session manager for your macOS menu bar"
  homepage "https://github.com/naufalafif/clam"

  depends_on macos: ">= :ventura"

  app "Clam.app"

  zap trash: [
    "~/Library/Preferences/com.naufal.clam.plist",
    "~/.cache/clam",
  ]
end
