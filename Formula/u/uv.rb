class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://github.com/astral-sh/uv/archive/refs/tags/0.5.12.tar.gz"
  sha256 "445a1256295aff91542ba417a3107cb88f088ab2263892b14ec5e195d955a819"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ad4e73764082a22dfe0112c1342c230af9a960d716da2b7affe1583d36f4b5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19de334da8d9cb73a10068d3cb851a3886ea66e8a053c8b9f1e9eaf6b1b890ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d640a05193cd2372f3a90d7364952566a42ace794f09e7ff51009153e8e5bacc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1db9f97bb5b8fe95a9aa7d13a259fa84513e34b79a3d35ce36fe196a0f886f23"
    sha256 cellar: :any_skip_relocation, ventura:       "e45ba84c61ce605ac280cbf5625684ccf1fc724f8ccbe4dbf8a9c3dbcc338945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f8f995ee0bf954fb85d242a3308ebf60853fd30f8041bfa0e809796714445b5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
    generate_completions_from_executable(bin/"uv", "generate-shell-completion")
    generate_completions_from_executable(bin/"uvx", "--generate-shell-completion", base_name: "uvx")
  end

  test do
    (testpath/"requirements.in").write <<~REQUIREMENTS
      requests
    REQUIREMENTS

    compiled = shell_output("#{bin}/uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}/uvx -q ruff@0.5.1 --version")
  end
end
