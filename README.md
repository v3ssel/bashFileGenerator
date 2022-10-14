# Bash File Generator

## WARNING! The script can destroy your system! Run it only in virtual machine!

## Creation

The `creation.sh` script creates a random number of folders and a random number of files in them, all files will be the size you specify.

The script creates one folder in a randomly selected folder on the system.

The script runs until a random number of folders are created or the root partition size is less than 1 GB(mostly).

Run it only on your own risk!

Usage: `sudo bash main.sh [a-zA-Z] [a-zA-Z].[a-zA-Z] [1-100mb]`.

## Delete created files

After executing the above script you can delete all created folders and files.

The `decreation.sh` script can delete all created files with 3 methods.

First is log deletion, after `creation.sh` in the startup directory will create `trasher.log`.

Run `sudo bash decreation.sh 1` to delete by this method.

Second is delete by date, **WARNING** -- this script will delete **ALL** files between two dates.

Run `sudo bash decreation.sh 2` to delete by this method.

And lastly, folder mask deletion, this method also requires `trasher.log`.
It will delete all folders that match the mask, for example:

Folders:
* `aaaz_011022`
* `azzz_011022`
* `aazz_011022`

Will be deleted by the mask: az_011022, but folder `aazzxx_011022` will exist.

Run `sudo bash decreation.sh 3` to delete by this method.

### P.S. If *trasher.log* has gone, the only way is second method, **please be careful!**
