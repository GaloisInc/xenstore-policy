
# xenstore-policy

Standalone security policy for the Mirage Xenstore using
libsepol.

The output of this package is a CPIO file named
"xenstore-ramdisk" containing a compiled security policy
along with path and context DBs.  This ramdisk is passed
to the Mirage Xenstore kernel as an initial Flask policy.
