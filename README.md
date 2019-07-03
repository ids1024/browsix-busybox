[![Build Status](https://travis-ci.org/ids1024/browsix-busybox.svg?branch=master)](https://travis-ci.org/ids1024/browsix-busybox)

![](https://ids1024.github.io/browsix-busybox/browsix-busybox.png)

This repo provides a port of (a subset of) Busybox to run in the browser inside [Browsix](https://github.com/plasma-umass/browsix).

This isn't fully functional, or on it's own particularly useful.

Building
========

This should be fairly easy to build, on a system with Docker available.

It is possible to build without Docker, but more difficult (and much more time consuming) since it requires llvm and clang compiled from the right branch, with a `~/.emscripten` file configured to point to their location.

To build using Docker and start an http server at `localhost:8080`:

```
git submodule update --init
sudo docker pull ids1024/browsix-build
./docker.sh make serve
```

Known issues
============
- Running a command is fairly slow, probably due to having to parse and compile a few megabytes of Javascript (the asm.js Busybox executable).
  * It should be possible to almost entirely eliminate this by switching to WebAssembly and caching the compiled [module](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WebAssembly/Module).
- Due to limitations in Browsix's synchronous system calls (in turn due to limitations of asm.js, and similarly for wasm), functionality that requires `fork()` is disabled. Thinks like `exec` are also not implemented, but should be straightforward to fix.
- There is no support currently for ptys in Browsix (the terminal is connected though pipes). This means programs can't do things like switch the terminal into raw mode. The most immediate result of this is that the `dash` shell doesn't print a prompt when not connected to a terminal.
