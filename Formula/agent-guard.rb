class AgentGuard < Formula
  desc "macOS menu bar security scanner for MCP servers and AI agent skills"
  homepage "https://github.com/naufalafif/agent-guard"
  url "https://github.com/naufalafif/agent-guard/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "8fd8049cb3a3ecee217036432080eb9737225673fc64fb077555ffeb30b96912"
  license "MIT"

  depends_on :macos
  depends_on "uv"

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    # Create .app bundle
    app_contents = prefix/"AgentGuard.app/Contents"
    (app_contents/"MacOS").mkpath
    (app_contents/"MacOS").install ".build/release/AgentGuard"
    app_contents.install "Info.plist"

    # Ad-hoc sign
    system "codesign", "--force", "--sign", "-", prefix/"AgentGuard.app"
  end

  def post_install
    ohai "Installing mcp-scanner..."
    system "uv", "tool", "install", "cisco-ai-mcp-scanner"

    ohai "Installing skill-scanner..."
    system "uv", "tool", "install", "cisco-ai-skill-scanner"

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

      To launch at login:
        Add AgentGuard.app in System Settings > General > Login Items

      To uninstall scanners:
        uv tool uninstall cisco-ai-mcp-scanner
        uv tool uninstall cisco-ai-skill-scanner
    EOS
  end

  test do
    assert_predicate prefix/"AgentGuard.app/Contents/MacOS/AgentGuard", :exist?
  end
end
