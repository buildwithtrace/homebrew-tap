class Buildwithtrace < Formula
  desc "AI-powered PCB design CLI"
  homepage "https://buildwithtrace.com"
  url "https://files.pythonhosted.org/packages/81/fa/f7127f6c5763aa8070d39970d4bd811ec8ea7f015b8c91d8c907ad3ad8f5/buildwithtrace-0.1.1.tar.gz"
  version "0.1.1"
  # url/version/sha256 are REWRITTEN by trace-cli's `update-homebrew` release job
  # (the sha256 is computed from the published tarball post-build — it can't be
  # known until the release artifact exists). The placeholder below is resolved
  # automatically on the first real release; do not hand-edit.
  sha256 "ed5bf5529fe4918ecb6ae5f5238f4d6a7ccc88bb5b5ea62924ed8fd4ab6f0f27"
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
