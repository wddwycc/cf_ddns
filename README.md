# cf_ddns

CloudFlare DDNS executable written in Swift.

The executable basically does this every 60 seconds.

```swift
findMyIP().flatMap { syncCF(ip: $0) }
```

## ENV

* `ZONE`:  Cloudflare zone
* `RECORD_TYPE`: DNS record type
* `RECORD_NAME`: DNS record name
* `EMAIL`: Cloudflare user email ( For authorization )
* `API_KEY`: Cloudflare API Key ( For authorization )

## Run with binary executable

```shell
git clone https://github.com/wddwycc/cf_ddns && cd cf_ddns
WITH_ENV swift run -c release
```

## Run with docker

Build docker image

```shell
git clone https://github.com/wddwycc/cf_ddns && cd cf_ddns
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
docker start my_ddns
# see logs of the started container
docker logs my_ddns -f
```
