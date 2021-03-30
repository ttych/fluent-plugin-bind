# fluent-plugin-bind

## Parser

### named_queries

**Parser for Bind/Named queries log format**.

Example of fluentd.conf:
```
<source>
  @type tail
  path /service/named/log/query.log
  pos_file query.pos
  tag named_query
  read_from_head true
  <parse>
    @type named_queries
  </parse>
</source>

<match named_query>
  @type stdout
</match>

```

## Copyright

* Copyright(c) 2021- Thomas Tych
* License
  * Apache License, Version 2.0

## References

- [Fluentd](https://fluentd.org/)
