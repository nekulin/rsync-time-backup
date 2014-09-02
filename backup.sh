#!/bin/sh
# Usage: rsync-backup.sh <src> <dst> <label>
if [ "$#" -ne 3 ]; then
    echo "$0: Expected 3 arguments, received $#: $@" >&2
    exit 1
fi
if [ ! -d "$1" ]; then
    echo "$1: There is no such directory" >&2
    exit 1
fi
if [ ! -d "$2" ]; then
    echo "$2: There is no such directory" >&2
    exit 1
fi
backup_dir=$2
fn_find_backups() {
find "$backup_dir" -type d | sort -r
}
fn_parse_date() {
date -d "$1" +%s ;
}
time() {
date  +%s;
}
for FILENAME in $(fn_find_backups | sort -r); do
	BACKUP_DATE=$(basename "$FILENAME")
	if [ $FILENAME = $backup_dir ]; then
		continue
	fi
	TIMESTAMP=$(fn_parse_date $BACKUP_DATE)
	time_=$(time)
	t=$(($time_-$TIMESTAMP)) ;
	if [ "$t" -gt 172800 ]; then
		rm -rf $FILENAME
	fi
done
rsync --archive $1 --delete $2$3
