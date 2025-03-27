class Efpclient < Formula
  include Language::Python::Virtualenv

  desc "This is an easy-to-use Python client to interact with the EF Portal REST API"
  homepage "https://github.com/NISP-GmbH/efpclient"
  url "https://test-files.pythonhosted.org/packages/89/0b/c2b82663f0a5e12eb5621b7f020a471d30e53185e2d97adef60ad3a2799d/efpclient-2025.0.2.tar.gz"
  version "25.0.2"
  sha256 "45e2765f55783674b59fe1eca349db655fe19cfdde96c58a6799b01907c1c48c"
  license "Apache-2.0"

  depends_on "python@3.13"

  def install
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install "-i https://test.pypi.org/simple/" "efpclient"
    venv.pip_install_and_link(buildpath, build_isolation: false)
  end

  test do
    # Simply run the program
    system `"efpclient"`
  end
end
