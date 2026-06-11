class Buildwithtrace < Formula
  desc "AI-powered PCB design CLI"
  homepage "https://buildwithtrace.com"
  url "https://files.pythonhosted.org/packages/7a/0f/f200c5460d12c57a765a5e6089a4812354ff73bf050600c86bb0891b39a9/buildwithtrace-0.1.4.tar.gz"
  version "0.1.4"
  # url/version/sha256 are REWRITTEN by trace-cli's `update-homebrew` release job
  # (the sha256 is computed from the published tarball post-build — it can't be
  # known until the release artifact exists). The placeholder below is resolved
  # automatically on the first real release; do not hand-edit.
  sha256 "7e9762518e8b27f3491d609bcf8172fc71593a3117628aa26f5b37c2e974bfe1"
  license "Proprietary"

  depends_on "python@3.12"

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install_and_link buildpath

    # Stamp the install origin so `buildwithtrace --version` / `doctor` label
    # this copy "(homebrew)" — the CLI reads <venv root>/trace-install-origin.
    (libexec/"trace-install-origin").write "homebrew\n"

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
