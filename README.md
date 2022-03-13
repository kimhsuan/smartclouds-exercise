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

# Plus
- [Plus](Plus)

## simple RESTful API

## Build Image
```bash
bash Plus/docker.sh build
```

push image to harbor
```bash
bash Plus/docker.sh push
```

run the container
```bash
bash Plus/docker.sh run
```
## Example
get all employees data
```
curl http://localhost:8080/employees
```

get an employee data by usermane
```
curl http://localhost:8080/employees/username1
```

add new employee
```
curl -X POST http://localhost:8080/employees \
    -H "Content-Type: application/json" \
    -d '{"id": "username4","email": "email4@email.com","mobile": "0987654324","position": {"title": "title4","department": "department4"}}'
```

update an employee's data
```
curl -X PATCH http://localhost:8080/employees/username3 \
    -H "Content-Type: application/json" \
    -d '{"id": "username3","email": "newemail3@email.com","mobile": "0987654323","position": {"title": "title3","department": "department3"}}'
```

delete an emplooyee
```
curl -X DELETE http://localhost:8080/employees/username4
```
