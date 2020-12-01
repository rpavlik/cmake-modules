# Ryan's CMake Modules Collection

Ryan A. Pavlik, Ph.D.

<ryan.pavlik@gmail.com> <abiryan@ryand.net>
<http://academic.cleardefinition.com>

<!--
Copyright 2009-2014, Iowa State University
Copyright 2014-2017, Sensics, Inc.
Copyright 2018-2020, Collabora, Ltd.
Copyright 2009-2020, Ryan A. Pavlik
Copyright 2011-2020, Contributors

SPDX-License-Identifier: BSL-1.0
-->

## Introduction

This is a collection of CMake modules that I've produced during the course
of a variety of software development.  There are a number of find modules,
especially for virtual reality and physical simulation packages, some utility
modules of more general interest, and some patches or workarounds for
(very old versions of) CMake itself.

Each module is generally documented, and depending on how busy I was
when I created it, the documentation can be fairly complete.

By now, it also includes contributions both from open-source projects I work on,
as well as friendly strangers on the Internet contributing their modules. I am
very grateful for improvements/fixes/pull requests! As usual, contributions to
files are assumed to be under the same license as they were offered to you
(incoming == outgoing), and any new files must have proper copyright and SPDX
license identifer headers.

## How to Integrate

How would you like to use these? Some of the modules, particularly older ones,
have a number of internal dependencies, and thus would be best placed wholesale
into a `cmake` subdirectory of your project source. Otherwise, you may consider
just picking the subset you prefer into such a `cmake` subdirectory.

### All Modules

If you use Git, try installing [git-subtree][1] (included by default on
Git for Windows and perhaps for your Linux distro, especially post-1.9.1), so
you can easily use this repository for subtree merges, updating simply.

For the initial checkout:

```sh
cd yourprojectdir

git subtree add --squash --prefix=cmake https://github.com/rpavlik/cmake-modules.git main
```

For updates:

```sh
cd yourprojectdir

git subtree pull --squash --prefix=cmake https://github.com/rpavlik/cmake-modules.git main
```

If you originally installed this by just copying the files, you'll sadly have to
delete the directory, commit that, then do the `git subtree add`. Annoying, but
I don't know a workaround. (Alternately you can use the method described below,
for the "subset of modules", to update.)

If you use some other version control, you can export a copy of this directory
without the git metadata by calling:

```sh
./export-to-directory.sh ../yourprojectdir/cmake
```

You might also consider exporting to a temp directory and merging changes, since
this will not overwrite by default.  You can pass -f to overwrite existing files.

### Just a few modules

Many newer modules don't have any or many internal dependencies. You can review
them to look for any `include(` statements or other things that increase the
files used (e.g. `configure_file(`, `file(READ`, `file(GENERATE`), and make sure
you copy those too.

If this is how you originally started using these modules, then running the
following from within a clone of this repo will automatically update any files.
**Be sure you have committed any local changes in your project first to avoid
potentially losing work!**

```sh
./update-modules.sh ../yourprojectdir/cmake/
```

Note that the script is not smart enough to know about changed dependent
scripts/files, nor about scripts with matching names but not originating in this
project (it just looks at file names/paths), so manually review the diff before
committing in your project.

## How to Use

At the minimum, all you have to do is add a line like this near the top
of your root CMakeLists.txt file (but not before your `project()` call):

```cmake
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
```

You might also want the extra automatic features/fixes included with the
modules, for that, just add another line following the first one:

```cmake
include(UseBackportedModules)
```

For more information on individual modules, look at the files themselves: they
should all start with a comment.

## Licenses

The modules that I wrote myself are all subject to this license:

> Copyright 2009-2014, Iowa State University.
> or Copyright 2014-2017, Sensics, Inc.,
> or Copyright 2018-2020, Collabora, Ltd.,
> or Copyright 2009-2020, Ryan A. Pavlik
>
> Distributed under the Boost Software License, Version 1.0.
>
> (See accompanying file `LICENSE_1_0.txt` or copy at
> <http://www.boost.org/LICENSE_1_0.txt>)

Modules based on those included with CMake are under the OSI-approved BSD
license, which is included in each of those modules. A few other modules are
modified from other sources - when in doubt, look at the `.cmake` file - each
file has correct licensing information.

If you'd like to contribute, that would be great! Just make sure to include
the license boilerplate in your module, and send a pull request.

## Important License Note

If you find this file inside of another project, rather at the top-level
directory, you're in a separate project that is making use of these modules.
That separate project can (and probably does) have its own license specifics.

[1]: https://github.com/git/git/tree/master/contrib/subtree  "Git Subtree upstream"
