#Rest interface for Responsys API 
[![Code Climate](https://codeclimate.com/github/TheBookPeople/responsys-rest/badges/gpa.svg)](https://codeclimate.com/github/TheBookPeople/responsys-rest) [![Test Coverage](https://codeclimate.com/github/TheBookPeople/responsys-rest/badges/coverage.svg)](https://codeclimate.com/github/TheBookPeople/responsys-rest) 
[![Build Status](https://travis-ci.org/TheBookPeople/responsys-rest.svg?branch=develop)](https://travis-ci.org/TheBookPeople/responsys-rest)

Rails application that provides a rest based interface for the Responsys SOAP API. Based on the [responsys-api](https://github.com/dandemeyere/responsys-api) gem by [dandemeyere](https://github.com/dandemeyere/). 

## Documentation

The documentation is included as part of the application. We have a demo version deployed to Heroku, none of the calls will work as the Responsys credentials are invalid.  https://responsys-rest.herokuapp.com/. If you have any questions or if you want to report a bug please create an [issue](https://github.com/TheBookPeople/responsys-rest/issues).

## Installation

You can checkout the repository and run as a normal Rails app, or install the application using a deb from [releases](https://github.com/TheBookPeople/responsys-rest/releases).

The deb has been created using [pkgr](https://github.com/crohr/pkgr).

### Installation From Source

```bash
git clone git@github.com:TheBookPeople/responsys-rest.git
cd responsys-rest
git checkout [TAG_VERSION]
bundle install
export RESPONSYS_USER=user
export RESPONSYS_PASSWORD=password
bundle exec rails s -b0.0.0.0
```

### Installation From Deb

Download deb file from [releases](https://github.com/TheBookPeople/responsys-rest/releases)

```bash
sudo apt-get install mysql-common
sudo dpkg -i responsys-rest_[VERSION]_amd64.deb
sudo vi /etc/responsys-rest/conf.d/other
```
#### Set Enviroment Variables

```bash
sudo vi /etc/responsys-rest/conf.d/other
```

```vim
export RESPONSYS_USER=user
export RESPONSYS_PASSWORD=password
export PORT=8081
```

#### Set Number of Web processes
```bash
sudo responsys-rest scale web=1
```

#### Check logs
```bash
sudo responsys-rest logs -f
```

## Running Tests
We use [VCR](https://github.com/vcr/vcr) to capture and replay calls to the Responsys SOAP API. 

```bash
export RESPONSYS_USER=user
export RESPONSYS_PASSWORD=password
bundle exec rspec
```

## Contributing

We use [gitflow](http://nvie.com/posts/a-successful-git-branching-model/) to manage our git workflow.

1. Fork it
2. Create your feature branch (`git checkout develop`)
3. Create your feature branch (`git checkout -b feature/my-new-feature`)
4. Commit your changes (`git commit -am "Add some feature"`)
5. Push to the branch (`git push origin feature/my-new-feature`)
6. Create new Pull Request