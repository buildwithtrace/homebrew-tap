class Buildwithtrace < Formula
  desc "AI-powered PCB design CLI"
  homepage "https://buildwithtrace.com"
  url "https://github.com/buildwithtrace/trace-cli/releases/latest/download/buildwithtrace-0.1.0.tar.gz"
  version "0.1.0"
  sha256 "REPLACE_WITH_REAL_SHA256"
  license "Proprietary"

  depends_on "python@3.12"

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install_and_link buildpath

    # Single canonical command: `buildwithtrace`. We deliberately do not link a
    # `trace` binary because it collides with the macOS system /usr/bin/trace.
    (bin/"buildwithtrace").write_env_script(
      libexec/"bin/buildwithtrace",
      PATH: "#{libexec}/bin:${PATH}"
    )
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buildwithtrace --version")
  end
end
