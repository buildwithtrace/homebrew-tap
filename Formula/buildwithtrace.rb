class Buildwithtrace < Formula
  desc "AI-powered PCB design CLI"
  homepage "https://buildwithtrace.com"
  url "https://files.pythonhosted.org/packages/3c/50/cb4ea613c35d62706a03a91697b53ee23c7500dbd2543aa1f472491a1017/buildwithtrace-0.1.3.tar.gz"
  version "0.1.3"
  # url/version/sha256 are REWRITTEN by trace-cli's `update-homebrew` release job
  # (the sha256 is computed from the published tarball post-build — it can't be
  # known until the release artifact exists). The placeholder below is resolved
  # automatically on the first real release; do not hand-edit.
  sha256 "16572421c4746ffdb9a2cdbca26e71d291f9e6afad97921073d214898ccee0c9"
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
