package { [imagemagick, imagemagick-dev, sqlite3]: ensure => installed, provider => fink }
package { [sqlite3-ruby, rmagick]: ensure => installed, provider => gem }
