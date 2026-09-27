cask "monitorkeys" do
  version "1.0.0"
  sha256 "e547e2719c0748785a2c3830ab44c68f6bfe616e277069f9d25268b4f6644e56"

  url "https://github.com/mevlut-geredeli/MonitorKeys/archive/refs/tags/v#{version}.tar.gz"
  name "MonitorKeys"
  desc "Keyboard volume keys for HDMI and DisplayPort monitors on Apple Silicon"
  homepage "https://github.com/mevlut-geredeli/MonitorKeys"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  # Built from source on your Mac with the Xcode Command Line Tools.
  preflight_steps do
    run "/bin/sh", args: ["build.sh"], chdir: "{{staged_path}}/MonitorKeys-{{version}}"
  end

  app "MonitorKeys-#{version}/build/MonitorKeys.app"

  uninstall quit:       "com.mevlutgeredeli.MonitorKeys",
            login_item: "MonitorKeys"

  zap trash: "~/Library/Preferences/com.mevlutgeredeli.MonitorKeys.plist"

  caveats <<~EOS
    MonitorKeys needs two one-time permissions: allow the system audio prompt on
    first launch, then use the menu bar item -> "Enable Keyboard Control..." to
    grant Accessibility.

    Homebrew builds are ad-hoc signed, so macOS asks for the Accessibility
    permission again after every `brew upgrade`. To avoid that, create a local
    signing identity once and re-sign the app after each upgrade:
      curl -fsSL https://raw.githubusercontent.com/mevlut-geredeli/MonitorKeys/main/scripts/make-signing-identity.sh | sh
      codesign --force --sign "MonitorKeys Local Signing" /Applications/MonitorKeys.app
  EOS
end
