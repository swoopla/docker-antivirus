# rordi/docker-antivirus

## Antivirus & Antimalware as a Microservice / as a Docker Container

[![](https://images.microbadger.com/badges/image/rordi/docker-antivirus.svg)](https://microbadger.com/images/rordi/docker-antivirus "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/rordi/docker-antivirus.svg)](https://microbadger.com/images/rordi/docker-antivirus "Get your own version badge on microbadger.com")

rordi/docker-antivirus is a virus and malware scanner as a Docker microservice. You can read an introduction here: https://www.linkedin.com/pulse/virus-malware-scanning-service-docker-dietrich-rordorf

The resulting Docker image runs inotify as the main process that watches a pre-defined volume for file write events and calls clamscan for each new file that is written into the volume. We do *not* use the ClamAV daemon, which has a constant, large memory consumption. 

### Notes
- **The image may only be built once per hour on the same IP address due to download limitations of the ClamAV signatures**
- a running container instance consumes around 10 MB memory when idle
- the image is maintained by Dietrich Rordorf, [Ediqo](https://www.ediqo.com/)
- initially the Dockerfile was prepared for [IWF](http://www.iwf.ch/web-solutions/)
- you can contribute to this project at https://github.com/rordi/docker-antivirus

#### Version 2
- released 06.11.2017
- use supervisord as main command, spawning inotify and cron as subprocesses
- refactor assets folder structure to reduce number of layers in resulting Docker image

#### Version 1
 - released 19.01.2017
 - first stable build

### Quick start

If you simply want to try out the setup, copy the docker-compose.yml file from the [repository](https://github.com/rordi/docker-antivirus) to your local file system and run:

    docker-compose up -d


### Introduction

This is a fork of [rordi/docker-antivirus](https://hub.docker.com/r/rordi/docker-antivirus/) Docker image running [Linux Malware Detect (LMD)](https://github.com/rfxn/linux-malware-detect) with [ClamAV](https://github.com/vrtadmin/clamav-devel) as the scanner.

This fork removes the inotify which sometimes doesn't work with MacOS and replaces it with a simple loop
that checks the directory every 30 seconds.

The container requires three volume mounts from where to take files to scan, and to deliver back scanned files and scan reports.

The container auto-updates the LMD and ClamAV virus signatures once per hour.

### Required volume mounts

Please provide the following volume mounts at runtime (e.g. in your docker-compose file). The antivirus container expects the following paths to be present when running:

        /data/av/queue         --> files to be checked
        /data/av/ok            --> checked files (ok)
        /data/av/nok           --> scan reports for infected files

Additionally, you may mount the quarantine folder and provide it to the antivirus container at the following path (this might be useful if you want to process the quarantined files from another container):

        /data/av/quarantine    --> quarantined files


### Using with docker-compose

In order to mount the directories and build the image if it does not exist on your system, run the following
command:

```
docker-compose up
```