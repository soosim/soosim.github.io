## msgpack

---
```
It's like JSON.but fast and small.

https://msgpack.org/
```

```php
<?php
    $data = array(0=>1,1=>2,2=>3);
    $msg = msgpack_pack($data);
    $data = msgpack_unpack($msg);
?>
```