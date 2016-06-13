# docker container for apache2php7

small docker container using supervisord to test-run php apps. no db link yet.

## usage

to build:
`docker build -t ymmer/apache2php7:1.0 .`

to run:
`docker run -p 8000:80  -m 512m --name="myApp" -d ymmer/apache2php7:1.0`
