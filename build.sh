#!/bin/bash
exec docker run --rm -v $PWD:/mnt -u $UID:$UID -it $(docker build -q .) cp /sshfs/build/sshfs /mnt/
