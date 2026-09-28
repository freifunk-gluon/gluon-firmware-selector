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
docker run -p 80:80 \
  -v /path/to/firmware/:/images:ro \
  -v /path/to/config.js:/usr/share/nginx/html/config.js:ro \
  --name web_firmware gluon-firmware-selector
```

The `directories` in `config.js` must match your mount layout. For example, if you use `/images/stable/factory` etc. as your default firmware layout (instead of `/images/factory`), use `'/images/stable/factory/'` in `directories`.

For https support check [jrcs/letsencrypt-nginx-proxy-companion](https://hub.docker.com/r/jrcs/letsencrypt-nginx-proxy-companion)

#### Docker with external device-pictures

In order to use the official [device-pictures repo](https://github.com/freifunk/device-pictures), pass `--target external-pictures` to build an image without the bundled pictures.

```sh
docker build --target external-pictures -t gluon-firmware-selector .
docker run -p 80:80 \
  -v /path/to/firmware/:/images:ro \
  -v /path/to/config.js:/usr/share/nginx/html/config.js:ro \
  -v /path/to/device-pictures/pictures-svg:/usr/share/nginx/html/pictures:ro \
  --name web_firmware gluon-firmware-selector
```

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

---

### Adding a device
To add a device follow these steps:

0. Check if the device has Gluon support. [This list]( https://github.com/freifunk-gluon/gluon/tree/main/targets) is where to check.
1. Make a fork and a branch for the device
2. Go into `devices.js`
3. Add the router to the correct list. See the [scheme above](#list-of-available-router-models)
  - If the device is still recommended use `devices_recommended`
  - Otherwise use the correct list, e.g. `devices_4_32` or `devices_ath10k_lowmem`
4. If Gluon can be installed **without modification** through the vendor UI, skip step 5
5. Add the installation instructions in the `devices_info` list. This is idealy an OpenWRT link, otherwise the Git commit of the device. The scheme is similar to the one in number 3. Just look at the other devices.
6. Kindly open a Pull Request. Thank you for your contribution!

### Adding a new picture
#### Similar looking device already exists

If there is a device which looks **very** similar to the one you want to add, you may just add a symlink. Look at the `pictures` directory for reference.

#### Completely new picture
Your device does not have a lookalike? Follow these steps:

0. Make sure the device already exists in the `devices.js`
1. Create the graphic using whatever software you like. However, it has to  support [vector graphics](https://en.wikipedia.org/wiki/Vector_graphics) (e.g. Inkscape, Draw.io, ...). This is needed so that you can export the image as SVG for the next step. Please do not just convert an JPG to SVG (vice versa is fine).
2. Before making a PR to this repo, please first add the device as SVG to the [device picture repo](https://github.com/freifunk/device-pictures). Preferably wait until that PR is merged, to avoid needing style changes in both repos on change requests
3. Make a fork, a branch and add your picture(s) to it. The name should always be the name listed in `devices.js`, e.g. netgear-rbr50.jpg for the Netgear Orbi RBR50. If the version is in the name, you have to include that too, e.g. netgear-wndr3700v2 and netgear-wndr3700v4.
4. Make sure your picture meets the following requirements:
    - The size is around 256px
    - No brand names are included in the picture (Netgear, Fritz, TP-Link, ...)
    - Has a white background
5. Make a PR. Please only make one PR per device (family) and don't mix them together. E.g. you may put all Netgear Orbi devices in one (same family, similar looking), but don't mix e.g. a Netgear Orbi with an Asus Lyra

---

### License
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
