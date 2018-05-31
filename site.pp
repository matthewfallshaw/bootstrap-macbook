# prerequisites
$username = 'matt'
if $username != $facts['identity']['user'] {
  fail("Wrong user - this manifest assumes that you're ${username}")
}

# TODO: ensure puppet modules present by pulling repo (note: can't rely on
# modules to pull repo)

Vcsrepo {
  provider => git,
  force  => false,
}
File {
  group => 'staff',
  owner => $username,
}
Package {
  provider => brew,
}

# puppet components
package { 'puppet-lint':
  ensure   => '1.1.0',
  provider => 'gem',
}

# vcsrepo { "/Users/${username}/.puppetlabs/etc/code/modules/puppet-launchd":
#   ensure   => present,
#   provider => git,
#   source   => 'https://github.com/macadmins/puppet-launchd.git',
# }


# homebrew
class { 'homebrew':
  user  => $username,
}
$pkglist_brew = ['cask', 'coreutils', 'ctags', 'findutils', 'fswatch', 'fzf',
'git', 'graphviz', 'imagemagick', 'm-cli', 'multimarkdown', 'mysql', 'node',
'pcre2', 'postgresql', 'qrencode', 'unrar', 'moreutils', 'python3', 'rbenv',
'the_silver_searcher', 'thefuck', 'tidy-html5', 'trash', 'tree', 'wget', 'z',
'zsh']
package { $pkglist_brew:
  ensure   => latest,
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


$home = "/Users/${username}"

# code
$code = "${home}/code"
file { $code:
  ensure => 'directory',
}

## dotfiles
vcsrepo { "${code}/dotfiles":
  ensure => present,
  source => 'https://github.com/matthewfallshaw/dotfiles.git',
}
# TODO: rake install dotfiles

# Google Play Music Desktop Player cli
vcsrepo { 'gpmdp_cli_repo':
  ensure => present,
  path   => "${code}/gpmdp-cli",
  source => {
    'origin'   => 'https://github.com/matthewfallshaw/gpmdp-cli.git',
    'upstream' => 'https://github.com/Glitch-is/gpmdp-cli.git'
  },
}
exec { 'gpmdp_cli_repo_requirements':
  refreshonly => true,
  subscribe   => Vcsrepo['gpmdp_cli_repo'],
  command     => 'pip3 install -r requirements.txt',
  path        => '/usr/local/bin/',
  cwd         => Vcsrepo['gpmdp_cli_repo']['path'],
}
file { "${Vcsrepo['gpmdp_cli_repo']['path']}/gpmdp-cli.py":
  ensure  => 'file',
  mode    => '0755',
  require => Vcsrepo['gpmdp_cli_repo'],
}
file { "${home}/bin/gpmdp-cli":
  ensure  => 'link',
  target  => "${Vcsrepo['gpmdp_cli_repo']['path']}/gpmdp-cli.py",
  require => Vcsrepo['gpmdp_cli_repo'],
}
exec { 'gpmdp_cli_repo_make':
  refreshonly => true,
  subscribe   => Vcsrepo['gpmdp_cli_repo'],
  command     => 'ln -sf gpmdp-cli.py ~/bin/gpmdp-cli',
  path        => '/usr/local/bin/',
  cwd         => Vcsrepo['gpmdp_cli_repo']['path'],
}

# source

$source = "${home}/source"
file { $source:
  ensure => 'directory',
}

vcsrepo { 'hammerspoon_spaces_repo':
  path   => "${source}/hs._asm.undocumented.spaces",
  source => 'https://github.com/asmagill/hs._asm.undocumented.spaces.git',
}
exec { 'hammerspoon_spaces_make':
  refreshonly => true,
  subscribe   => Vcsrepo['hammerspoon_spaces_repo'],
  command     => 'make install',
  path        => '/usr/bin/',
  cwd         => "${source}/hs._asm.undocumented.spaces",
}
