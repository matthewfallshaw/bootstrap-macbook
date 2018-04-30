$username = 'matt'
if $username != $facts['identity']['user'] {
  fail("Wrong user - this manifest assumes that you're ${username}")
}


package { 'puppet-lint':
  ensure   => '1.1.0',
  provider => 'gem',
}


# puppet modules
# vcsrepo { "/Users/${username}/.puppetlabs/etc/code/modules/puppet-launchd":
#   ensure   => present,
#   provider => git,
#   source   => 'https://github.com/macadmins/puppet-launchd.git',
# }


# homebrew
class { 'homebrew':
  user  => $username
}
$pkglist_brew = ['cask', 'coreutils', 'findutils', 'fswatch', 'fzf', 'git',
  'graphviz', 'imagemagick', 'm-cli', 'multimarkdown', 'mysql', 'node',
  'pcre2', 'postgresql', 'qrencode', 'unrar', 'moreutils', 'rbenv',
  'the_silver_searcher', 'thefuck', 'tidy-html5', 'trash', 'tree', 'wget', 'z',
  'zsh']
package { $pkglist_brew:
  ensure   => latest,
  provider => brew,
}

$pkglist_brewcask = ['macvim', 'betterzipql', 'electrum', 'rowanj-gitx',
  'gpg-suite', 'grandperspective', 'keybase', 'keycue', 'launchcontrol',
  'libreoffice', 'qlcolorcode', 'qlmarkdown', 'qlstephen', 'quicklook-csv',
  'quicklook-json', 'rstudio', 'skype', 'suspicious-package', 'unison',
  'virtualbox', 'vagrant', 'xquartz']
package { $pkglist_brewcask:
  ensure   => latest,
  provider => brewcask,
}


# code
## dotfiles
file { [ "/Users/${username}/code", "/Users/${username}/code/dotfiles" ]:
  ensure => 'directory',
  mode   => '0755',
}
vcsrepo { "/Users/${username}/code/dotfiles":
  ensure   => present,
  provider => git,
  source   => 'https://github.com/matthewfallshaw/dotfiles.git',
  force    => false,
}
