Unilib & C3UI
==============

Important
-----------

Unilib is synchronized with a folder in the library C3UI.

Specifically, C3UI "External/Unilib" directory is synchronized with "Unilib/Sources". Synchronization is done using an application specific for this (e.g. Chronosync or other). Additionally, whenever synchronization is complete a shell script is run which ensures all Unilib "public" API is converted to "internal" when used in C3UI, and vise-versa on the side of Unilib -- "internal" is converted back to "public". This script may be run automatically from the synchronization application, but it **must** be run. (There is more information in the script itself -- currently maintained by me, David.)

It is done this way for 2 reasons:
1. to avoid having excess public API show up in the C3UI library.
2. to allow Unilib to exist as an independent library with it's own public API

Currently, the Swift ecosystem (including package management) has no support for this type of architecture.

NOTE: There are some exceptions where Unilib code is used in the public API of C3UI. For example, debugging, some math operators, etc. In these cases it's necessary to suffix the visibility modifier with the notation /**/ to prevent the synchronization script from flipping this API back to internal.

Example: public/**/ class Foobar { }

Changes
----------

1. Implementation changes can happen in C3UI or in Unilib.

2. Filesystem changes will generally happen in Unilib (the original project).

When syncronizing, if there are conflicts, generally default to the side the change happened on. Remember that both sides are under Git version control so it's easy fix problems if they occur (assuming the working directories are clean before the synchronization is performed). 

Actions
-------

Sync libraries using Chronosync 

Run the following script
```
cd ~/Code/Scripts
sh ./SyncUnilib.sh
```
Commit changes
