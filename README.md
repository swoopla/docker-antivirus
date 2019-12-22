# Antivirus & Antimalware in a Docker Container

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

### Notes
- **The image may only be built once per hour on the same IP address due to download limitations of the ClamAV signatures**
- a running container instance consumes around 10 MB memory when idle

