# Full Tron Node in Docker
## Runs on CentOs 7 (will be ported to Alpine later)
### Current Version : Odyssey-v2.0.8.1



```
docker run -it -d \
--name=TronNode \
-p 50051:50051 \
-p 50052:50052 \
-v /nodes/tron/logs/:/tron/logs:z \
-v /nodes/tron/data/:/tron/output-directory:z \
paradoxforge/nodes.tron.full:latest
```

