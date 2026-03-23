class AgentGuard < Formula
  desc "macOS menu bar security scanner for MCP servers and AI agent skills"
  homepage "https://github.com/naufalafif/agent-guard"
  url "https://github.com/naufalafif/agent-guard/releases/download/v1.1.0/agent-guard-1.1.0.tar.gz"
  sha256 "d9a007db2e62a5d724a84e7b2c2ccd3534a7bce74dd311d2a622b7ef55fa7a97"
  license "MIT"

  depends_on :macos
  depends_on "uv"

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    # Create .app bundle with icon
    app_contents = prefix/"AgentGuard.app/Contents"
    (app_contents/"MacOS").mkpath
    (app_contents/"Resources").mkpath
    (app_contents/"MacOS").install ".build/release/AgentGuard"
    app_contents.install "Info.plist"
    (app_contents/"Resources").install "AppIcon.icns"

    # Ad-hoc sign
    system "codesign", "--force", "--sign", "-", prefix/"AgentGuard.app"
  end

  def post_install
    # Scanners are best-effort — the app auto-installs on first launch if missing
    ohai "Installing mcp-scanner..."
    system "uv", "tool", "install", "--force", "cisco-ai-mcp-scanner" rescue nil

    ohai "Installing skill-scanner..."
    system "uv", "tool", "install", "--force", "cisco-ai-skill-scanner" rescue nil

    # Initialize config and cache dirs
    config_dir = Pathname.new(Dir.home)/".config/mcp-scan"
    cache_dir = Pathname.new(Dir.home)/".cache/mcp-scan"
    config_dir.mkpath
    cache_dir.mkpath

    unless (config_dir/"config").exist?
      (config_dir/"config").write("SCAN_INTERVAL=30  # Scan interval in minutes\n")
    end
    unless (cache_dir/"ignore.json").exist?
      (cache_dir/"ignore.json").write("[]\n")
    end
  end

  def caveats
    <<~EOS
      To start AgentGuard:
        open #{prefix}/AgentGuard.app

      Or search "AgentGuard" in Spotlight.

      To launch at login:
        Open AgentGuard > Settings > Launch at login
    EOS
  end

  test do
    assert_predicate prefix/"AgentGuard.app/Contents/MacOS/AgentGuard", :exist?
    assert_predicate prefix/"AgentGuard.app/Contents/Resources/AppIcon.icns", :exist?
  end
end
