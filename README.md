# cf_ddns

CloudFlare DDNS executable written in Swift.

The executable basically does this.

```swift
findMyIP().flatMap { syncCF(ip: $0) }
```

## How to run

Build docker image

```shell
docker build . \
--tag cf_ddns:1.0 \
--build-arg zone=x \
--build-arg recordType=A \
--build-arg recordName=base.monk-studio.com \
--build-arg email=wddwyss@gmail.com \
--build-arg apiKey=x \
```

Create container and run

```shell
docker create --name my_ddns cf_ddns:1.0
docker start -a my_ddns
```
