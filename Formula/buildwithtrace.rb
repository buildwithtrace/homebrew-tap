class Buildwithtrace < Formula
  desc "AI-powered PCB design CLI"
  homepage "https://buildwithtrace.com"
  url "https://files.pythonhosted.org/packages/94/60/175aaf5f9f6bbd485425c5484478c7e3bdc3cc2f2af1cf299221a5d38241/buildwithtrace-0.1.6.tar.gz"
  version "0.1.6"
  # url/version/sha256 are REWRITTEN by trace-cli's `update-homebrew` release job
  # (the sha256 is computed from the published tarball post-build — it can't be
  # known until the release artifact exists). The placeholder below is resolved
  # automatically on the first real release; do not hand-edit.
  sha256 "cd4dcb4c65faaf05d3259146c6d2e6a7e601d6f7d75dd9943bea4c8e35d7e9ed"
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
