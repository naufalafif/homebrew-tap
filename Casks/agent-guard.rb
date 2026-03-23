cask "agent-guard" do
  version "1.2.0"
  sha256 "839ab559d820e98a407b296f64ec25889cbc33e97df4452828a2f827004057d9"

  url "https://github.com/naufalafif/agent-guard/releases/download/v#{version}/AgentGuard.zip"
  name "AgentGuard"
  desc "macOS menu bar security scanner for MCP servers and AI agent skills"
  homepage "https://github.com/naufalafif/agent-guard"

  depends_on macos: ">= :ventura"

  app "AgentGuard.app"

  postflight do
    # App auto-installs scanners on first launch, but try to pre-install via uv if available
    system_command "/bin/bash", args: ["-lc", "command -v uv && uv tool install cisco-ai-mcp-scanner 2>/dev/null; true"]
    system_command "/bin/bash", args: ["-lc", "command -v uv && uv tool install cisco-ai-skill-scanner 2>/dev/null; true"]
  end

  zap trash: [
    "~/.cache/mcp-scan",
    "~/.config/mcp-scan",
  ]

  caveats <<~EOS
    AgentGuard has been installed to /Applications.

    Open it from Spotlight or:
      open /Applications/AgentGuard.app

    The app auto-installs mcp-scanner and skill-scanner on first launch.

    To launch at login:
      Open AgentGuard > Settings > Launch at login
  EOS
end
