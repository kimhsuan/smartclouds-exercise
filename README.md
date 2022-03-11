smartclouds-exercise
===
# Basic
- [Basic](Basic)

## Note
only test in Ubuntu 20.04.4 LTS (Focal Fossa)!!

## Useage

### Docker Containers
first copy .env.example to .env
```bash
bash Basic/ctl.sh copy-env
```

and generate mysql root password
```bash
bash Basic/ctl.sh generate-password
```

build laravel image
```bash
bash Basic/ctl.sh build
```

push laravel image to harbor
```bash
bash Basic/ctl.sh push
```

compose up all container
```bash
bash Basic/ctl.sh start
```

### mysql Import and Backup
backup mysql
```bash
bash Basic/ctl.sh create-mysql-backup
```

Delete Backupfiles older than 10 days
```bash
bash Basic/ctl.sh delete-mysql-backup
```
