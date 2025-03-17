# Overview

Tired of doing the same boring operations each time I have to set up my common development environment, I decided to create this script which is intended to automatize the installation and configuration of a LAMP WordPress-development environment based on Ubuntu. It contains a basic set of instructions for installing Apache, PHP, MariaDB, NodeJS and a bunch of utilities that I have been using for years.

Currently it is focused on Ubuntu 24.04, I do not reject to add more distros in the future though.

## Content

- Apache2
    - Modules: `rewrite, headers, ssl, expires, proxy, proxy_http`
- MariaDB (latest stable version)
    - User: `root`
    - Pass: `toor`
- PHP (latest stable version)
    - Modules: `mysqli, cli, gd, mbstring, common, xml, json, curl, zip, apcu`
- ZSH + OhMyZSH + Powerlevel 10k
    - OhMyZSH plugins: `autosuggestions, syntax-highlighting`
- Custom ZSH aliases
- Custom Git aliases
- Composer
- NodeJS + NPM
- WP Cli + Bash completion
- Utils
    - DoComposer: installs composer recursively based on Git Submodules
    - NewRelase: creates a new release for a Plugin or Theme. See details below.

## How to use

In your Linux console, launch the next command. Change `{version}` for the selected Distro version:

```bash
curl -sS https://raw.githubusercontent.com/davidnaviaweb/php-dev-env/refs/heads/main/{version}/setup.sh | sudo bash
```

### NewRelease details

This tool createas a new release for a plugin or theme based on the git repository you lauch the script.
```bash
$ NewRelease --type
```
It accepts three options for `type`, depending on the type of release you want to create based on the [Semantic Version](https://semver.org/) standard.

```bash
$ NewRelease major
$ NewRelease minor
$ NewRelease patch
```
The script will detect whether you are in a plugin or a theme repository and it will update the version number on the main plugin file or the `style.css` theme file. After that, it will create a git commit and a tag automatically. 