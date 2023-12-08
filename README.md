# M6809-toolshed

Toolshed is a collection of tools and source code for the Tandy Color Computer and Dragon computers.

The repository contains:
- `os9` and `decb` for copying files to/from host file systems to disk images
- CoCo & Dragon system ROM source code, and source code for custom ROMs like HDB-DOS, DriveWire DOS, and SuperDOS
- Microware C compiler souce code for cross-hosted compilation (currently needs work)
- Assemblers to perform cross-development from Windows, Linux, and macOS (see the NOTE below on assembler recommendations)
- Other miscellaneous tools

**NOTE:** while the venerable 6809 cross-assembler, mamou, is part of the repository, it is only kept for historical value. Everyone should really be using William Astle's excellent LWTOOLS which contains the *lwasm* 6809 assembler and *lwlink* linker. [Download the latest version of the source here.](http://lwtools.projects.l-w.ca)

## Building on debian

The preferred way: To build cocofuse for Linux, you need FUSE libraries and header files installed.
```
$ sudo apt install libfuse-dev
```

Enter the unpackaged toolshed directory and run:
```
$ make -C build/unix install
```

## Building HDB-DOS and DriveWire DOS

It is highly recommended to have [LWTOOLS](http://lwtools.projects.l-w.ca/) installed. You also need `makewav` to build WAV files. See **hdbdos/README.txt** and the makefiles for different build options.

To build all default flavors:
```
$ make -C dwdos
$ make -C hdbdos
$ make -C superdos
```

Instead of LWTOOLS, you can use the deprecated `mamou`:
```
$ make -C dwdos AS="mamou -r -q"
$ make -C hdbdos AS="mamou -r -q"
```

Note that SuperDOS still builds with `mamou` by default.
