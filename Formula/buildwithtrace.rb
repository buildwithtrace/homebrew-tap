class Buildwithtrace < Formula
  desc "AI-powered PCB design CLI"
  homepage "https://buildwithtrace.com"
  url "https://github.com/buildwithtrace/cli/releases/download/v0.1.1/buildwithtrace-0.1.1.tar.gz"
  version "0.1.1"
  # url/version/sha256 are REWRITTEN by trace-cli's `update-homebrew` release job
  # (the sha256 is computed from the published tarball post-build — it can't be
  # known until the release artifact exists). The placeholder below is resolved
  # automatically on the first real release; do not hand-edit.
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
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
