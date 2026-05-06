# D2 Icon URLs

All URLs are from `icons.terrastruct.com` and should render with `d2 --bundle`. Attach via the node's `icon:` property. **Do not invent URLs** - if a tech is not listed here, use shape-only from the known-unavailable list or omit the icon.

Always render with `d2 --bundle ...` so these URLs are fetched once and inlined as data URIs.

## Databases & stores

| Tech          | URL                                                                |
| ------------- | ------------------------------------------------------------------ |
| PostgreSQL    | `https://icons.terrastruct.com/dev%2Fpostgresql.svg`               |
| MySQL         | `https://icons.terrastruct.com/dev%2Fmysql.svg`                    |
| MongoDB       | `https://icons.terrastruct.com/dev%2Fmongodb.svg`                  |
| Redis         | `https://icons.terrastruct.com/dev%2Fredis.svg`                    |

## Languages & runtimes

| Tech    | URL                                              |
| ------- | ------------------------------------------------ |
| Go      | `https://icons.terrastruct.com/dev%2Fgo.svg`     |
| Python  | `https://icons.terrastruct.com/dev%2Fpython.svg` |
| Node.js | `https://icons.terrastruct.com/dev%2Fnodejs.svg` |

## Containers & orchestration

| Tech   | URL                                              |
| ------ | ------------------------------------------------ |
| Docker | `https://icons.terrastruct.com/dev%2Fdocker.svg` |

## Observability

No observability URLs are currently vetted. Use shape-only nodes from the known-unavailable list for Grafana, Prometheus, Datadog, tracing, logging, and metrics systems.

## AWS

| Service       | URL                                                                                            |
| ------------- | ---------------------------------------------------------------------------------------------- |
| S3            | `https://icons.terrastruct.com/aws%2FStorage%2FAmazon-Simple-Storage-Service-S3.svg`          |
| RDS           | `https://icons.terrastruct.com/aws%2FDatabase%2FAmazon-RDS.svg`                                |
| DynamoDB      | `https://icons.terrastruct.com/aws%2FDatabase%2FAmazon-DynamoDB.svg`                           |
| ElastiCache   | `https://icons.terrastruct.com/aws%2FDatabase%2FAmazon-ElastiCache.svg`                        |
| Lambda        | `https://icons.terrastruct.com/aws%2FCompute%2FAWS-Lambda.svg`                                 |
| ECS           | `https://icons.terrastruct.com/aws%2FCompute%2FAmazon-Elastic-Container-Service.svg`           |

## Generic / essentials

| Tech   | URL                                                              |
| ------ | ---------------------------------------------------------------- |
| Users  | `https://icons.terrastruct.com/essentials%2F359-users.svg`       |
| Server | `https://icons.terrastruct.com/tech%2F022-server.svg`            |

## Known unavailable icons (use shape-only, no `icon:`)

These technologies commonly have CDN URLs that return 403 or fail bundling. Use a fitting `shape` instead:

| Tech                         | Replacement                |
| ---------------------------- | -------------------------- |
| Kafka                        | `shape: queue`             |
| Kubernetes                   | `shape: hexagon`           |
| Elasticsearch / OpenSearch   | `shape: cylinder`          |
| Grafana                      | `shape: cloud`             |
| Prometheus                   | `shape: cloud`             |
| AWS Region group             | container label, no icon   |
| AWS Application LB           | `shape: hexagon`           |
| AWS CloudFront / CDN         | `shape: cloud`             |
| Datadog                      | `shape: cloud`             |
| Stripe                       | `shape: cloud`             |
| Generic cloud                | `shape: cloud`             |

Example:

```d2
broker: Events (Kafka) { class: queue }   # queue class already sets shape: queue
alb:    ALB            { class: edge; shape: hexagon }
```
