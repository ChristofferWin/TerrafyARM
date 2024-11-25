class YourApp < Formula
    desc "Transform Azure ARM templates to Terraform with ease. Export ARM templates via CLI and use TerrafyARM to compile it to valid Terraform code"
    homepage "https://www.codeterraform.com/"
    url "https://github.com/ChristofferWin/TerrafyARM/releases/download/0.1.0-alpha/terrafyarm-macos-amd64.tar.gz"
    sha256 "87da7008de8790b6181b5df079442469641f3505ec5a28cd71326204f12b4e5c"
    license "MIT"
  
    def install
      bin.install "terrafyarm"
    end
  
    test do
      system "#{bin}/terrafyarm", "--version"
    end
  end
