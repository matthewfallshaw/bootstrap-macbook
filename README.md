# Bootstrap Macbook

A Masterless Puppet setup to build my macbook.

## Install
``` bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"  # install homebrew
brew install cask git
brew cask install puppet-agent
puppet module install puppetlabs-vcsrepo
puppet module install thekevjames-homebrew
mkdir -p ~/code
cd ~/code
git clone https://github.com/matthewfallshaw/bootstrap-macbook.git
cd bootstrap-macbook
puppet apply --test site.pp
```
