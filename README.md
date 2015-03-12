# docker-moodle-coderunner
=============

A Dockerfile that installs and runs the latest Moodle stable with CodeRunner plugin.

## Installation

```
git clone https://github.com/ashi880/docker-moodle-coderunner
cd docker-moodle-coderunner
docker build -t moodle .
```

## Usage

To spawn a new instance of Moodle:

```
docker run -d --name DB -p 3306:3306 -e MYSQL_DATABASE=moodle -e MYSQL_USER=moodle -e MYSQL_PASSWORD=moodle centurylink/mysql
docker run -d -P --name crmoodle --link DB:DB -e MOODLE_URL=http://192.168.59.103:8080/moodle -p 8080:80 moodle
```

You can visit the following URL in a browser to get started:

```
http://192.168.59.103:8080/moodle 
```

## Credits

This is a reductionist take on [jda](https://github.com/jda/)'s docker-moodle Dockerfile.

