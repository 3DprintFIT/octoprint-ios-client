![](https://travis-ci.com/3DprintFIT/octoprint-ios-client.svg?token=cBbYdr39gVRVpvBLcJ1U&branch=release)
[![codebeat badge](https://codebeat.co/badges/f2a97050-74db-47c1-a050-daf71d57c7c9)](https://codebeat.co/projects/github-com-3dprintfit-octoprint-ios-client)
[![codecov](https://codecov.io/gh/3DprintFIT/octoprint-ios-client/branch/dev/graph/badge.svg)](https://codecov.io/gh/3DprintFIT/octoprint-ios-client)

# octoprint-ios-client

# Local usage

## Docker setup

You can run octoprint in docker for testing purposes (on virtual printer). Simply run docker container:

```bash
$ docker run -p"32768:5000" josefdolezal/octophone-local

```

Octoprint now runs on port `32768`.

App should be able to find your docker OctoPrint instance and connect to it.

### Login

In docker container is test user called `octophone` with `octophone` password. There is pregenerated access token for your app:

```
76DA2D98FFF8447681E1A5C6420B8F4F
```

Now you are set up. OctoPhone is now available to control virtual printer.
