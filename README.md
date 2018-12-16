# cf_ddns

CloudFlare DDNS executable written in Swift.

The executable basically do this.

```swift
findMyIP().flatMap { syncCF(ip: $0) }
```

Run with env variable

* zone: Cloudflare zone
* recordType: DNS record type
* recordName: DNS record name
* email: Cloudflare user email ( For authorization )
* apiKey: Cloudflare API Key ( For authorization )

Example:

```shell
recordType=A recordName=base.monk-studio.com email=wddwyss@gmail.com apiKey=xx cf_ddns
```
