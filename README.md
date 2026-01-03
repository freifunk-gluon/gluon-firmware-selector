OpenWrt/LEDE Firmware Wizard
---

This Firmware Wizard lets a user select the correct firmware for his device. Directory listings are used to parse the list of available images.

Similar projects:
- [Freifunk Bielefeld Firmware Wizard](https://github.com/freifunk-bielefeld/firmware-wizard/): Based on this wizard, but also supports LEDE and OpenWRT firmware images
- [LibreMesh Chef](https://github.com/libremesh/chef): Firmware wizard of LibreMesh that supports building custom images on demand

### Screenshot
![screenshot of the firmware wizard](screenshot.png)

### Configuration
Image paths and available branches can be set in `config_template.js` which has to be renamed to `config.js`. In addition, directory listings have to be enabled in your prefered web server:

#### Apache Webserver
Create a `.htaccess` file that enables directory listings:
```
Options +Indexes
```

#### Nginx Webserver
For `nginx`, auto-indexing has to be turned on:
```
location /path/to/builds/ {
    autoindex on;
}
```

#### Python Webserver
For testing purposes or to share files in a LAN, Python can be used. Run `python -m http.server 8080` from within this directory (the directory where `README.md` can be found) and you are done.

#### Docker
```
docker build -t gluon-firmware-selector .
docker run -p 80:80 -v /path/to/firmware/:/images:ro -v /path/to/config.js:/usr/share/nginx/html/config.js:ro --name web_firmware gluon-firmware-selector
```
For https support check [jrcs/letsencrypt-nginx-proxy-companion](https://hub.docker.com/r/jrcs/letsencrypt-nginx-proxy-companion)


### List of available router models
All available router models are specified in `devices.js` via that will match against the filenames.
If no hardware revision is given or is it is empty, the revision is extracted from the file name.

```
{
  <vendor>: {
    <model>: <match>,
    <model>: {<match>: <revision>, ...}
    ...
  }, ...
}
```

If two matches overlap, the longest match will be assigned the matching files. On the other hand, the same match can be used by multiple models without problems.

### Adding a device
To add a device follow these steps:

0. Check if the device has Gluon support. [This list](https://github.com/freifunk-gluon/gluon/blob/main/docs/user/supported_devices.rst) is where to check.
1. Make a fork and a branch for the device
2. Go into `devices.js`
3. Add the router to the correct list. See the [scheme above](#list-of-available-router-models)
  - If the device is still recommended use `devices_recommended`
  - Otherwise use the correct list, e.g. `devices_4_32` or `devices_ath10k_lowmem`
4. If Gluon can be installed **without modification** through the vendor UI, skip step 5
5. Add the installation instructions in the `devices_info` list. This is idealy an OpenWRT link, otherwise the Git commit of the device. The scheme is similar to the one in number 3. Just look at the other devices.
6. Kindly open a Pull Request. Thank you for your contribution!

### License
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
