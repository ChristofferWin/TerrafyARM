class YourApp < Formula
    desc "Transform Azure ARM templates to Terraform with ease. Export ARM templates via CLI and use TerrafyARM to compile it to valid Terraform code"
    homepage "https://www.codeterraform.com/"
    url "https://github.com/ChristofferWin/TerrafyARM/releases/download/0.1.0-alpha/terrafyarm-macos-amd64.tar.gz"
    sha256 "your_binary_sha256_hash"
    license "MIT"
  
    def install
      bin.install "terrafyarm"
    end
  
    test do
      system "#{bin}/terrafyarm", "--version"
    end
  end