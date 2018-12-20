# cf_ddns

CloudFlare DDNS executable written in Swift.

The executable basically does this.

```swift
findMyIP().flatMap { syncCF(ip: $0) }
```

Run with env variables

* `ZONE`:  Cloudflare zone
* `RECORD_TYPE`: DNS record type
* `RECORD_NAME`: DNS record name
* `EMAIL`: Cloudflare user email ( For authorization )
* `API_KEY`: Cloudflare API Key ( For authorization )

Example:

```shell
recordType=A recordName=base.monk-studio.com email=wddwyss@gmail.com apiKey=xx cf_ddns
```

Download executable from [release page](https://github.com/wddwycc/cf_ddns/releases)
