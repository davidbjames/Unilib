Unilib & C3
==============

Important
-----------

Unilib is synchronized with a folder in the library C3.

Specifically, C3 "External/Unilib" directory is synchronized with "Unilib/Sources". Synchronization is done using an application specific for this (e.g. Chronosync or other). Additionally, whenever synchronization is complete a shell script is run which ensures all Unilib "public" API is converted to "internal" when used in C3, and vica versa on the side of Unilib -- "internal" is converted back to "public". This script may be run automatically from the synchronization application, but it **must** be run. (There is more information in the script itself -- currently maintained by me, David.)

It is done this way for 2 reasons:
1. to avoid having excess public API show up in the C3 library.
2. to allow Unilib to exist as an independent library with it's own public API

Currently, the Swift ecosystem (including package management) has no support for this type of architecture.


Changes
----------

1. Implementation changes can happen in C3 or in Unilib.

2. Filesystem changes will generally happen in Unilib (the original project).

When syncronizing, if there are conflicts, generally default to the side the change happened on. Remember that both sides are under Git version control so it's easy fix problems if they occur (assuming the working directories are clean before the synchronization is performed). 
