# pwnbox
[![](https://github.com/nicolaipre/pwnbox/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/nicolaipre/pwnbox/actions)

Heavily based on (pretty much ripped) [pwndocker](https://github.com/skysider/pwndocker).

Workflow inspired by Kileak:
```shell
alias go='docker -exec -it $1 /bin/bash'
$ go 22.04
$ go 16.04

# ubuntu:22.04
# ubuntu:20.04
# ubuntu:18.04
# ubuntu:16.04
# ubuntu:14.04
# ubuntu:12.04
```

## To-Do
- [ ] Figure out if we can just use https://libc.rip and https://libc.blukat.me instead...


### Usage
```shell
# build
$ make build

# shell
$ make shell

# or
$ docker exec -it pwndocker /bin/bash
```

---

### Included glibc
Default compiled glibc path is `/glibc`.

- 2.19  —— ubuntu 12.04 default libc version
- 2.23  —— ubuntu 16.04 default libc version
- 2.24  —— introduce vtable check in file struct
- 2.27  —— ubuntu 18.04 default glibc version
- 2.28~2.30  —— latest libc versions
- 2.31  —— ubuntu 20.04 default glibc version(built-in)

#### How to run in custom libc version?
```shell
$ cp /glibc/2.27/64/lib/ld-2.27.so /tmp/ld-2.27.so
$ patchelf --set-interpreter /tmp/ld-2.27.so ./test
$ LD_PRELOAD=./libc.so.6 ./test
```

or
```python
from pwn import *
p = process(["/path/to/ld.so", "./test"], env={"LD_PRELOAD":"/path/to/libc.so.6"})
```

#### How to run in custom libc version with other lib?
If you want to run binary with glibc version 2.28:
```shell
root@pwn:/ctf/work# ldd /bin/ls
linux-vdso.so.1 (0x00007ffe065d3000)
libselinux.so.1 => /lib/x86_64-linux-gnu/libselinux.so.1 (0x00007f004089e000)
libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f00406ac000)
libpcre2-8.so.0 => /lib/x86_64-linux-gnu/libpcre2-8.so.0 (0x00007f004061c000)
libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f0040616000)
/lib64/ld-linux-x86-64.so.2 (0x00007f00408f8000)

root@pwn:/ctf/work# /glibc/2.28/64/ld-2.28.so /bin/ls
/bin/ls: error while loading shared libraries: libselinux.so.1: cannot open shared object file: No such file or directory
```
You can copy /lib/x86_64-linux-gnu/libselinux.so.1 and /lib/x86_64-linux-gnu/libpcre2-8.so.0 to /glibc/2.28/64/lib/, and sometimes it fails because the built-in libselinux.so.1 requires higher version libc:

```shell
root@pwn:/ctf/work# /glibc/2.28/64/ld-2.28.so /bin/ls
/bin/ls: /glibc/2.28/64/lib/libc.so.6: version `GLIBC_2.30' not found (required by /glibc/2.28/64/lib/libselinux.so.1)
```

It can be solved by copying libselinux.so.1 from ubuntu 18.04 which glibc version is 2.27 to /glibc/2.28/64/lib:
```shell
$ docker run -itd --name u18 ubuntu:18.04 /bin/bash
$ docker cp -L u18:/lib/x86_64-linux-gnu/libselinux.so.1 .
$ docker cp -L u18:/lib/x86_64-linux-gnu/libpcre2-8.so.0 .
$ docker cp libselinux.so.1 pwn:/glibc/2.28/64/lib/
$ docker cp libpcre2-8.so.0 pwn:/glibc/2.28/64/lib/
```

And now it succeeds:
```shell
root@pwn:/ctf/work# /glibc/2.28/64/ld-2.28.so /bin/ls -l /
```
