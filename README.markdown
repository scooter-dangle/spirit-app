spirit-app
==========

_Less Money, More API_


Ruby version
------------
The Gemfile currently lists 2.1.1, but you may need to change it locally to list a version close to 2.1.1 that you already have installed. There currently is an issue with installing 2.1.1 through rbenv's ruby-build plugin.

Setup
-----
  ```sh
  git clone https://github.com/scooter-dangle/spirit-app.git
  cd spirit-app
  bundle
  ```

Edit the MySql username and password fields in config/database.yml to reflect your local database. Then:
  ```sh
  rake db:setup
  rake test:all
  ```

Run
---


System dependencies
-------------------
If you have a Ruby 2.1.x version already installed on your system as well as mysql-server and a working version of the bundle and mysql2 gems, you may be fine with just running `bundle`. If not, Ubuntu users will likely need the following packages before installing Ruby and mysql2:

*  build-essential
*  autoconf
*  bison
*  libssl-dev
*  libyaml-dev
*  libreadline6
*  libreadline6-dev
*  zlib1g
*  zlib1g-dev
*  libmysqlclient-dev
*  mysql-server

On Mac OS X, the [ruby-build wiki](https://github.com/sstephenson/ruby-build/wiki) says to (_direct quote follows_) install Xcode Command Line Tools (`xcode-select --install`) and Homebrew. Then:

  ```sh
    brew install mysql

  # optional, but recommended:
    brew install openssl libyaml
  ```

(Note: I don't have access to a machine with Mac OS X. If you end up having to do some Googling to get this to work on a Mac, let me know, and I'll update this README accordingly.)

If you're on Windows (or another system) and are interested in trying out this project, please let me know (i.e., file an issue), and I'll look into it. I don't have ready access though to a Windows machine with install privileges, so I may need your help in figuring this out.


After getting all the dependencies above installed, run `gem install bundler`.

Other potential setup issues
----------------------------
If you installed bundler using a different version of Ruby, you may need (I think) uninstall and re-install with with `gem install bundler --env-shebang`. Your results may vary and depend on what ruby version manager you use.


* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
