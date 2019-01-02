# Full Tron Node in Docker
## Runs on CentOs 7 (will be ported to Alpine later)
### Current Version : Odyssey-v3.2.3

#### Environment Variables
- **NETWORK**
  - Valid Options : "main", "test"
  - Default : "main"

```
docker run -it \
--name=TronNode \
-p 18888:18888 \
-p 50051:50051 \
-e NETWORK="test" \
-v //C/B/tron/logs/:/tron/logs:z \
-v //C/B/tron/data/:/tron/output-directory:z \
paradoxforge/nodes.tron.full:latest
```

