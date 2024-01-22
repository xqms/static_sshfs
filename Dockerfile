
FROM rockylinux:8.7

RUN dnf -y install --enablerepo=devel meson ninja-build gcc cmake glib2-devel glib2-static glibc-static git

RUN git clone https://github.com/libfuse/libfuse.git
RUN git clone https://github.com/libfuse/sshfs.git

RUN mkdir -p /libfuse/build && cd /libfuse/build && meson setup --default-library static --prefix=/usr .. && ninja install

RUN mkdir -p /sshfs/build && cd /sshfs/build && meson setup --default-library static -D c_link_args="-static" .. && cat build.ninja

RUN cd /sshfs/build && gcc -o sshfs -static -pthread -I. -I.. -I/usr/include/fuse3 -I/usr/include/glib-2.0 -I/usr/lib64/glib-2.0/include -D_FILE_OFFSET_BITS=64 -Wall -Winvalid-pch -O2 -g -D_REENTRANT -DHAVE_CONFIG_H -Wall -Wextra -Wno-sign-compare -Wmissing-declarations -Wwrite-strings -Wno-unused-result -pthread -DFUSE_USE_VERSION=31 ../sshfs.c ../cache.c /usr/lib64/libfuse3.a /usr/lib64/libglib-2.0.a /usr/lib64/libgthread-2.0.a -ldl

