class Buildwithtrace < Formula
  desc "AI-powered PCB design CLI"
  homepage "https://buildwithtrace.com"
  url "https://files.pythonhosted.org/packages/e9/1f/99fd5cadab9b2df2f5746fa9e1c3305619f84554cf2b1f22b07524705c19/buildwithtrace-0.1.5.tar.gz"
  version "0.1.5"
  # url/version/sha256 are REWRITTEN by trace-cli's `update-homebrew` release job
  # (the sha256 is computed from the published tarball post-build — it can't be
  # known until the release artifact exists). The placeholder below is resolved
  # automatically on the first real release; do not hand-edit.
  sha256 "3fd72f213a8029501ccacd504c0f37a107e6482f61ac4ca537f70fe1a1c0d46c"
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
