# Antivirus & Antimalware in a Docker Container

Adapted from https://github.com/rordi/docker-antivirus for ad-hoc scanning, as opposed to inotify-triggered scanning in the original project.

Autobuilt image available as [cheewai/docker-antivirus](https://hub.docker.com/r/cheewai/docker-antivirus/)

## Usage

Both ClamAV and Linux Malware Detect (LMD) are updated frequently. To reduce start-up time and avoid redundant downloading, you should run one instance of this container in the background (daemon mode).

- Clone this repo

- Edit `docker-compose.yml` to adjust local directory paths for `clamav` and `maldetect` in the volumes section. These directories will be used to persist downloaded malware database. Say we have these volume mapping:

    - /path/to/maldetect:/usr/local/maldetect
    - /path/to/clamav:/var/lib/clamav

- `chmod ugo+w /path/to/maldetect /path/to/clamav`

- Run container in the background, `docker-compose up -d`. This container will refresh the malware database as frequently as defined in `assets/install_antivirus.sh` (default is once every hour).

- Monitor initial update progress and wait until update is complete, `docker-compose logs -f` 

- From now on, you can launch one or more instances of the antivirus scanner concurrently, all sharing the same malware database

```
docker run --rm -v /path/to/maldetect:/usr/local/maldetect -v /path/to/clamav:/var/lib/clamav -v /path/to/scan:/target --entrypoint=/usr/local/bin/duoscan.sh cheewai/docker-antivirus /target
```

- In case of multiple scan directories, just add more `-v ...` options and also append them to the end of command line

- `duoscan.sh` calls `clamscan` and `maldet` in sequence with default options. You may override the entrypoint script to run them with your preferred options

    - clamscan, https://linux.die.net/man/1/clamscan
    - maldet, https://www.rfxn.com/appdocs/README.maldetect
