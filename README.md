# linuxpro-homework06
# Управление пакетами. Дистрибьюция софта

1. [Подготовим VM в Vagrant](#1)
2. [Работа в ВМ - сбор своего пакета](#2)
3. [Создаем репозиторий](#3)
4. [Автоматизация](#4)
5. [Проверка](#5)

* * *
<a name="1"/>

## Подготовим VM в Vagrant
Vagrantfile
```bash
ujack@ubuntu2004:~/linuxpro-homework06$ cat Vagrantfile
# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
        config.vm.box = "centos/7"
        config.vm.box_version = "2004.01"
        config.vm.provider "virtualbox" do |v|
        v.memory = 256
        v.cpus = 1
        end
        config.vm.define "pack" do |pack|
        pack.vm.hostname = "pack"
#        pack.vm.provision "shell", path: "pack_script.sh"
        end
end
```

* * *
<a name="2"/>

## Работа в ВМ - сбор своего пакета
установим необходимые пакеты
```bash
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils
Loaded plugins: fastestmirror
Determining fastest mirrors
 * base: mirror.corbina.net
 * extras: mirror.corbina.net
 * updates: mirror.yandex.ru
base                                                                                                        | 3.6 kB  00:00:00
extras                                                                                                      | 2.9 kB  00:00:00
updates                                                                                                     | 2.9 kB  00:00:00
(1/4): extras/7/x86_64/primary_db                                                                           | 243 kB  00:00:00
(2/4): base/7/x86_64/group_gz                                                                               | 153 kB  00:00:00
(3/4): base/7/x86_64/primary_db                                                                             | 6.1 MB  00:00:01
(4/4): updates/7/x86_64/primary_db                                                                          |  13 MB  00:00:02
Resolving Dependencies
--> Running transaction check
...
...
Installed:
  createrepo.noarch 0:0.9.9-28.el7      redhat-lsb-core.x86_64 0:4.1-27.el7.centos.1      rpm-build.x86_64 0:4.11.3-48.el7_9
  rpmdevtools.noarch 0:8.3-8.el7_9      wget.x86_64 0:1.14-18.el7_6.1

Dependency Installed:
  at.x86_64 0:3.1.13-24.el7                                   bc.x86_64 0:1.06.95-13.el7
  cups-client.x86_64 1:1.6.3-51.el7                           dwz.x86_64 0:0.11-3.el7
  ed.x86_64 0:1.9-4.el7                                       elfutils.x86_64 0:0.176-5.el7
  emacs-filesystem.noarch 1:24.3-23.el7                       gdb.x86_64 0:7.6.1-120.el7
  m4.x86_64 0:1.4.16-10.el7                                   mailx.x86_64 0:12.5-19.el7
  patch.x86_64 0:2.7.1-12.el7_7                               perl.x86_64 4:5.16.3-299.el7_9
  perl-Carp.noarch 0:1.26-244.el7                             perl-Encode.x86_64 0:2.51-7.el7
  perl-Exporter.noarch 0:5.68-3.el7                           perl-File-Path.noarch 0:2.09-2.el7
  perl-File-Temp.noarch 0:0.23.01-3.el7                       perl-Filter.x86_64 0:1.49-3.el7
  perl-Getopt-Long.noarch 0:2.40-3.el7                        perl-HTTP-Tiny.noarch 0:0.033-3.el7
  perl-PathTools.x86_64 0:3.40-5.el7                          perl-Pod-Escapes.noarch 1:1.04-299.el7_9
  perl-Pod-Perldoc.noarch 0:3.20-4.el7                        perl-Pod-Simple.noarch 1:3.28-4.el7
  perl-Pod-Usage.noarch 0:1.63-3.el7                          perl-Scalar-List-Utils.x86_64 0:1.27-248.el7
  perl-Socket.x86_64 0:2.010-5.el7                            perl-Storable.x86_64 0:2.45-3.el7
  perl-Text-ParseWords.noarch 0:3.29-4.el7                    perl-Thread-Queue.noarch 0:3.02-2.el7
  perl-Time-HiRes.x86_64 4:1.9725-3.el7                       perl-Time-Local.noarch 0:1.2300-2.el7
  perl-constant.noarch 0:1.27-2.el7                           perl-libs.x86_64 4:5.16.3-299.el7_9
  perl-macros.x86_64 4:5.16.3-299.el7_9                       perl-parent.noarch 1:0.225-244.el7
  perl-podlators.noarch 0:2.5.1-3.el7                         perl-srpm-macros.noarch 0:1-8.el7
  perl-threads.x86_64 0:1.87-4.el7                            perl-threads-shared.x86_64 0:1.43-6.el7
  psmisc.x86_64 0:22.20-17.el7                                python-deltarpm.x86_64 0:3.6-3.el7
  python-srpm-macros.noarch 0:3-34.el7                        redhat-lsb-submod-security.x86_64 0:4.1-27.el7.centos.1
  redhat-rpm-config.noarch 0:9.1.0-88.el7.centos              spax.x86_64 0:1.5.2-13.el7
  time.x86_64 0:1.7-45.el7                                    unzip.x86_64 0:6.0-24.el7_9
  zip.x86_64 0:3.0-11.el7

Updated:
  yum-utils.noarch 0:1.1.31-54.el7_8

Dependency Updated:
  cups-libs.x86_64 1:1.6.3-51.el7           elfutils-libelf.x86_64 0:0.176-5.el7          elfutils-libs.x86_64 0:0.176-5.el7
  rpm.x86_64 0:4.11.3-48.el7_9              rpm-build-libs.x86_64 0:4.11.3-48.el7_9       rpm-libs.x86_64 0:4.11.3-48.el7_9
  rpm-python.x86_64 0:4.11.3-48.el7_9

Complete!

```
Загрузим SRPM пакет NGINX длā далþнейшей работý над ним:
```bash
[root@pack ~]# wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
--2022-02-21 14:56:15--  https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
Resolving nginx.org (nginx.org)... 3.125.197.172, 52.58.199.22, 2a05:d014:edb:5702::6, ...
Connecting to nginx.org (nginx.org)|3.125.197.172|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1033399 (1009K) [application/x-redhat-package-manager]
Saving to: ‘nginx-1.14.1-1.el7_4.ngx.src.rpm’

100%[=========================================================================================>] 1,033,399   3.69MB/s   in 0.3s

2022-02-21 14:56:15 (3.69 MB/s) - ‘nginx-1.14.1-1.el7_4.ngx.src.rpm’ saved [1033399/1033399]
```
При установке такого пакета в домашней директории создаетсā древо каталогов длā
сборки:
```bash
[root@pack ~]# rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm
warning: nginx-1.14.1-1.el7_4.ngx.src.rpm: Header V4 RSA/SHA1 Signature, key ID 7bd9bf62: NOKEY
warning: user builder does not exist - using root
warning: group builder does not exist - using root
warning: user builder does not exist - using root
warning: group builder does not exist - using root
warning: user builder does not exist - using root
warning: group builder does not exist - using root
warning: user builder does not exist - using root
warning: group builder does not exist - using root
warning: user builder does not exist - using root
warning: group builder does not exist - using root
warning: user builder does not exist - using root
warning: group builder does not exist - using root
warning: user builder does not exist - using root
warning: group builder does not exist - using root
warning: user builder does not exist - using root
warning: group builder does not exist - using root
warning: user builder does not exist - using root
warning: group builder does not exist - using root
warning: user builder does not exist - using root
warning: group builder does not exist - using root
warning: user builder does not exist - using root
warning: group builder does not exist - using root
warning: user builder does not exist - using root
warning: group builder does not exist - using root
warning: user builder does not exist - using root
warning: group builder does not exist - using root
warning: user builder does not exist - using root
warning: group builder does not exist - using root
[root@pack ~]# ll
total 1028
-rw-------. 1 root root    5570 Apr 30  2020 anaconda-ks.cfg
-rw-r--r--. 1 root root 1033399 Nov  6  2018 nginx-1.14.1-1.el7_4.ngx.src.rpm
-rw-------. 1 root root    5300 Apr 30  2020 original-ks.cfg
drwxr-xr-x. 4 root root      34 Feb 21 14:58 rpmbuild
[root@pack ~]# ll rpmbuild/
total 4
drwxr-xr-x. 2 root root 4096 Feb 21 14:58 SOURCES
drwxr-xr-x. 2 root root   24 Feb 21 14:58 SPECS

```
Также нужно скачать и разархивировать последний исходники для openssl - он
потребуется при сборке:
```bash
[root@pack ~]# wget https://www.openssl.org/source/openssl-3.0.1.tar.gz --no-check-certificate
--2022-02-21 15:07:00--  https://www.openssl.org/source/openssl-3.0.1.tar.gz
Resolving www.openssl.org (www.openssl.org)... 23.13.245.172, 2001:2030:21:193::c1e, 2001:2030:21:1a3::c1e
Connecting to www.openssl.org (www.openssl.org)|23.13.245.172|:443... connected.
WARNING: cannot verify www.openssl.org's certificate, issued by ‘/C=US/O=Let's Encrypt/CN=R3’:
  Issued certificate has expired.
HTTP request sent, awaiting response... 200 OK
Length: 15011207 (14M) [application/x-gzip]
Saving to: ‘openssl-3.0.1.tar.gz’

100%[=========================================================================================>] 15,011,207  8.13MB/s   in 1.8s

2022-02-21 15:07:02 (8.13 MB/s) - ‘openssl-3.0.1.tar.gz’ saved [15011207/15011207]
```
Разархивируем
```bash
[root@pack ~]# tar -xvf openssl-3.0.1.tar.gz
```
Заранее поставим все зависимости чтобý в процессе сборки не бýло ошибок
```bash
[root@pack ~]# yum-builddep rpmbuild/SPECS/nginx.spec
Loaded plugins: fastestmirror
Enabling base-source repository
Enabling extras-source repository
Enabling updates-source repository
Loading mirror speeds from cached hostfile
 * base: mirror.corbina.net
 * extras: mirror.corbina.net
 * updates: mirror.yandex.ru
base                                                                                                        | 3.6 kB  00:00:00
base-source                                                                                                 | 2.9 kB  00:00:00
extras                                                                                                      | 2.9 kB  00:00:00
extras-source                                                                                               | 2.9 kB  00:00:00
updates                                                                                                     | 2.9 kB  00:00:00
updates-source                                                                                              | 2.9 kB  00:00:00
(1/3): extras-source/7/primary_db                                                                           |  30 kB  00:00:00
(2/3): updates-source/7/primary_db                                                                          | 221 kB  00:00:00
(3/3): base-source/7/primary_db                                                                             | 974 kB  00:00:01
Checking for new repos for mirrors
Getting requirements for rpmbuild/SPECS/nginx.spec
 --> Already installed : redhat-lsb-core-4.1-27.el7.centos.1.x86_64
 --> Already installed : systemd-219-73.el7_8.5.x86_64
 --> 1:openssl-devel-1.0.2k-24.el7_9.x86_64
 --> zlib-devel-1.2.7-19.el7_9.x86_64
 --> pcre-devel-8.32-17.el7.x86_64
--> Running transaction check
---> Package openssl-devel.x86_64 1:1.0.2k-24.el7_9 will be installed
--> Processing Dependency: openssl-libs(x86-64) = 1:1.0.2k-24.el7_9 for package: 1:openssl-devel-1.0.2k-24.el7_9.x86_64
--> Processing Dependency: krb5-devel(x86-64) for package: 1:openssl-devel-1.0.2k-24.el7_9.x86_64
---> Package pcre-devel.x86_64 0:8.32-17.el7 will be installed
---> Package zlib-devel.x86_64 0:1.2.7-19.el7_9 will be installed
--> Processing Dependency: zlib = 1.2.7-19.el7_9 for package: zlib-devel-1.2.7-19.el7_9.x86_64
Package: zlib-1.2.7-19.el7_9.src - can't co-install with zlib-1.2.7-19.el7_9.x86_64
Package: zlib-1.2.7-19.el7_9.src - can't co-install with zlib-1.2.7-19.el7_9.x86_64
--> Running transaction check
---> Package krb5-devel.x86_64 0:1.15.1-51.el7_9 will be installed
--> Processing Dependency: libkadm5(x86-64) = 1.15.1-51.el7_9 for package: krb5-devel-1.15.1-51.el7_9.x86_64
--> Processing Dependency: krb5-libs(x86-64) = 1.15.1-51.el7_9 for package: krb5-devel-1.15.1-51.el7_9.x86_64
--> Processing Dependency: libverto-devel for package: krb5-devel-1.15.1-51.el7_9.x86_64
--> Processing Dependency: libselinux-devel for package: krb5-devel-1.15.1-51.el7_9.x86_64
--> Processing Dependency: libcom_err-devel for package: krb5-devel-1.15.1-51.el7_9.x86_64
--> Processing Dependency: keyutils-libs-devel for package: krb5-devel-1.15.1-51.el7_9.x86_64
---> Package openssl-libs.x86_64 1:1.0.2k-19.el7 will be updated
--> Processing Dependency: openssl-libs(x86-64) = 1:1.0.2k-19.el7 for package: 1:openssl-1.0.2k-19.el7.x86_64
---> Package openssl-libs.x86_64 1:1.0.2k-24.el7_9 will be an update
---> Package zlib.x86_64 0:1.2.7-18.el7 will be updated
---> Package zlib.x86_64 0:1.2.7-19.el7_9 will be an update
--> Running transaction check
---> Package keyutils-libs-devel.x86_64 0:1.5.8-3.el7 will be installed
---> Package krb5-libs.x86_64 0:1.15.1-46.el7 will be updated
---> Package krb5-libs.x86_64 0:1.15.1-51.el7_9 will be an update
---> Package libcom_err-devel.x86_64 0:1.42.9-19.el7 will be installed
--> Processing Dependency: libcom_err(x86-64) = 1.42.9-19.el7 for package: libcom_err-devel-1.42.9-19.el7.x86_64
---> Package libkadm5.x86_64 0:1.15.1-51.el7_9 will be installed
---> Package libselinux-devel.x86_64 0:2.5-15.el7 will be installed
--> Processing Dependency: libsepol-devel(x86-64) >= 2.5-10 for package: libselinux-devel-2.5-15.el7.x86_64
--> Processing Dependency: pkgconfig(libsepol) for package: libselinux-devel-2.5-15.el7.x86_64
---> Package libverto-devel.x86_64 0:0.2.5-4.el7 will be installed
---> Package openssl.x86_64 1:1.0.2k-19.el7 will be updated
---> Package openssl.x86_64 1:1.0.2k-24.el7_9 will be an update
--> Running transaction check
---> Package libcom_err.x86_64 0:1.42.9-17.el7 will be updated
--> Processing Dependency: libcom_err(x86-64) = 1.42.9-17.el7 for package: e2fsprogs-libs-1.42.9-17.el7.x86_64
--> Processing Dependency: libcom_err(x86-64) = 1.42.9-17.el7 for package: e2fsprogs-1.42.9-17.el7.x86_64
--> Processing Dependency: libcom_err(x86-64) = 1.42.9-17.el7 for package: libss-1.42.9-17.el7.x86_64
---> Package libcom_err.x86_64 0:1.42.9-19.el7 will be an update
---> Package libsepol-devel.x86_64 0:2.5-10.el7 will be installed
--> Running transaction check
---> Package e2fsprogs.x86_64 0:1.42.9-17.el7 will be updated
---> Package e2fsprogs.x86_64 0:1.42.9-19.el7 will be an update
---> Package e2fsprogs-libs.x86_64 0:1.42.9-17.el7 will be updated
---> Package e2fsprogs-libs.x86_64 0:1.42.9-19.el7 will be an update
---> Package libss.x86_64 0:1.42.9-17.el7 will be updated
---> Package libss.x86_64 0:1.42.9-19.el7 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

===================================================================================================================================
 Package                              Arch                    Version                               Repository                Size
===================================================================================================================================
Installing:
 openssl-devel                        x86_64                  1:1.0.2k-24.el7_9                     updates                  1.5 M
 pcre-devel                           x86_64                  8.32-17.el7                           base                     480 k
 zlib-devel                           x86_64                  1.2.7-19.el7_9                        updates                   50 k
Installing for dependencies:
 keyutils-libs-devel                  x86_64                  1.5.8-3.el7                           base                      37 k
 krb5-devel                           x86_64                  1.15.1-51.el7_9                       updates                  273 k
 libcom_err-devel                     x86_64                  1.42.9-19.el7                         base                      32 k
 libkadm5                             x86_64                  1.15.1-51.el7_9                       updates                  179 k
 libselinux-devel                     x86_64                  2.5-15.el7                            base                     187 k
 libsepol-devel                       x86_64                  2.5-10.el7                            base                      77 k
 libverto-devel                       x86_64                  0.2.5-4.el7                           base                      12 k
Updating for dependencies:
 e2fsprogs                            x86_64                  1.42.9-19.el7                         base                     701 k
 e2fsprogs-libs                       x86_64                  1.42.9-19.el7                         base                     168 k
 krb5-libs                            x86_64                  1.15.1-51.el7_9                       updates                  809 k
 libcom_err                           x86_64                  1.42.9-19.el7                         base                      42 k
 libss                                x86_64                  1.42.9-19.el7                         base                      47 k
 openssl                              x86_64                  1:1.0.2k-24.el7_9                     updates                  494 k
 openssl-libs                         x86_64                  1:1.0.2k-24.el7_9                     updates                  1.2 M
 zlib                                 x86_64                  1.2.7-19.el7_9                        updates                   90 k

Transaction Summary
===================================================================================================================================
Install  3 Packages (+7 Dependent packages)
Upgrade             ( 8 Dependent packages)

Total download size: 6.3 M
Is this ok [y/d/N]: y
Downloading packages:
No Presto metadata available for base
No Presto metadata available for updates
(1/18): e2fsprogs-libs-1.42.9-19.el7.x86_64.rpm                                                             | 168 kB  00:00:00
(2/18): e2fsprogs-1.42.9-19.el7.x86_64.rpm                                                                  | 701 kB  00:00:00
(3/18): keyutils-libs-devel-1.5.8-3.el7.x86_64.rpm                                                          |  37 kB  00:00:00
(4/18): libcom_err-1.42.9-19.el7.x86_64.rpm                                                                 |  42 kB  00:00:00
(5/18): libselinux-devel-2.5-15.el7.x86_64.rpm                                                              | 187 kB  00:00:00
(6/18): libsepol-devel-2.5-10.el7.x86_64.rpm                                                                |  77 kB  00:00:00
(7/18): libss-1.42.9-19.el7.x86_64.rpm                                                                      |  47 kB  00:00:00
(8/18): libverto-devel-0.2.5-4.el7.x86_64.rpm                                                               |  12 kB  00:00:00
(9/18): krb5-devel-1.15.1-51.el7_9.x86_64.rpm                                                               | 273 kB  00:00:00
(10/18): openssl-1.0.2k-24.el7_9.x86_64.rpm                                                                 | 494 kB  00:00:00
(11/18): libkadm5-1.15.1-51.el7_9.x86_64.rpm                                                                | 179 kB  00:00:00
(12/18): libcom_err-devel-1.42.9-19.el7.x86_64.rpm                                                          |  32 kB  00:00:00
(13/18): zlib-1.2.7-19.el7_9.x86_64.rpm                                                                     |  90 kB  00:00:00
(14/18): zlib-devel-1.2.7-19.el7_9.x86_64.rpm                                                               |  50 kB  00:00:00
(15/18): openssl-devel-1.0.2k-24.el7_9.x86_64.rpm                                                           | 1.5 MB  00:00:00
(16/18): pcre-devel-8.32-17.el7.x86_64.rpm                                                                  | 480 kB  00:00:00
(17/18): krb5-libs-1.15.1-51.el7_9.x86_64.rpm                                                               | 809 kB  00:00:00
(18/18): openssl-libs-1.0.2k-24.el7_9.x86_64.rpm                                                            | 1.2 MB  00:00:00
-----------------------------------------------------------------------------------------------------------------------------------
Total                                                                                              3.5 MB/s | 6.3 MB  00:00:01
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : libcom_err-1.42.9-19.el7.x86_64                                                                                1/26
  Updating   : zlib-1.2.7-19.el7_9.x86_64                                                                                     2/26
  Updating   : krb5-libs-1.15.1-51.el7_9.x86_64                                                                               3/26
  Updating   : 1:openssl-libs-1.0.2k-24.el7_9.x86_64                                                                          4/26
  Installing : libkadm5-1.15.1-51.el7_9.x86_64                                                                                5/26
  Installing : zlib-devel-1.2.7-19.el7_9.x86_64                                                                               6/26
  Updating   : e2fsprogs-libs-1.42.9-19.el7.x86_64                                                                            7/26
  Updating   : libss-1.42.9-19.el7.x86_64                                                                                     8/26
  Installing : libcom_err-devel-1.42.9-19.el7.x86_64                                                                          9/26
  Installing : libsepol-devel-2.5-10.el7.x86_64                                                                              10/26
  Installing : libverto-devel-0.2.5-4.el7.x86_64                                                                             11/26
  Installing : keyutils-libs-devel-1.5.8-3.el7.x86_64                                                                        12/26
  Installing : pcre-devel-8.32-17.el7.x86_64                                                                                 13/26
  Installing : libselinux-devel-2.5-15.el7.x86_64                                                                            14/26
  Installing : krb5-devel-1.15.1-51.el7_9.x86_64                                                                             15/26
  Installing : 1:openssl-devel-1.0.2k-24.el7_9.x86_64                                                                        16/26
  Updating   : e2fsprogs-1.42.9-19.el7.x86_64                                                                                17/26
  Updating   : 1:openssl-1.0.2k-24.el7_9.x86_64                                                                              18/26
  Cleanup    : 1:openssl-1.0.2k-19.el7.x86_64                                                                                19/26
  Cleanup    : e2fsprogs-1.42.9-17.el7.x86_64                                                                                20/26
  Cleanup    : 1:openssl-libs-1.0.2k-19.el7.x86_64                                                                           21/26
  Cleanup    : krb5-libs-1.15.1-46.el7.x86_64                                                                                22/26
  Cleanup    : e2fsprogs-libs-1.42.9-17.el7.x86_64                                                                           23/26
  Cleanup    : libss-1.42.9-17.el7.x86_64                                                                                    24/26
  Cleanup    : libcom_err-1.42.9-17.el7.x86_64                                                                               25/26
  Cleanup    : zlib-1.2.7-18.el7.x86_64                                                                                      26/26
  Verifying  : libselinux-devel-2.5-15.el7.x86_64                                                                             1/26
  Verifying  : zlib-1.2.7-19.el7_9.x86_64                                                                                     2/26
  Verifying  : krb5-libs-1.15.1-51.el7_9.x86_64                                                                               3/26
  Verifying  : 1:openssl-libs-1.0.2k-24.el7_9.x86_64                                                                          4/26
  Verifying  : pcre-devel-8.32-17.el7.x86_64                                                                                  5/26
  Verifying  : keyutils-libs-devel-1.5.8-3.el7.x86_64                                                                         6/26
  Verifying  : 1:openssl-devel-1.0.2k-24.el7_9.x86_64                                                                         7/26
  Verifying  : libverto-devel-0.2.5-4.el7.x86_64                                                                              8/26
  Verifying  : libcom_err-1.42.9-19.el7.x86_64                                                                                9/26
  Verifying  : 1:openssl-1.0.2k-24.el7_9.x86_64                                                                              10/26
  Verifying  : e2fsprogs-libs-1.42.9-19.el7.x86_64                                                                           11/26
  Verifying  : zlib-devel-1.2.7-19.el7_9.x86_64                                                                              12/26
  Verifying  : libkadm5-1.15.1-51.el7_9.x86_64                                                                               13/26
  Verifying  : libsepol-devel-2.5-10.el7.x86_64                                                                              14/26
  Verifying  : libss-1.42.9-19.el7.x86_64                                                                                    15/26
  Verifying  : e2fsprogs-1.42.9-19.el7.x86_64                                                                                16/26
  Verifying  : krb5-devel-1.15.1-51.el7_9.x86_64                                                                             17/26
  Verifying  : libcom_err-devel-1.42.9-19.el7.x86_64                                                                         18/26
  Verifying  : e2fsprogs-libs-1.42.9-17.el7.x86_64                                                                           19/26
  Verifying  : libcom_err-1.42.9-17.el7.x86_64                                                                               20/26
  Verifying  : krb5-libs-1.15.1-46.el7.x86_64                                                                                21/26
  Verifying  : 1:openssl-libs-1.0.2k-19.el7.x86_64                                                                           22/26
  Verifying  : zlib-1.2.7-18.el7.x86_64                                                                                      23/26
  Verifying  : e2fsprogs-1.42.9-17.el7.x86_64                                                                                24/26
  Verifying  : 1:openssl-1.0.2k-19.el7.x86_64                                                                                25/26
  Verifying  : libss-1.42.9-17.el7.x86_64                                                                                    26/26

Installed:
  openssl-devel.x86_64 1:1.0.2k-24.el7_9         pcre-devel.x86_64 0:8.32-17.el7         zlib-devel.x86_64 0:1.2.7-19.el7_9

Dependency Installed:
  keyutils-libs-devel.x86_64 0:1.5.8-3.el7     krb5-devel.x86_64 0:1.15.1-51.el7_9      libcom_err-devel.x86_64 0:1.42.9-19.el7
  libkadm5.x86_64 0:1.15.1-51.el7_9            libselinux-devel.x86_64 0:2.5-15.el7     libsepol-devel.x86_64 0:2.5-10.el7
  libverto-devel.x86_64 0:0.2.5-4.el7

Dependency Updated:
  e2fsprogs.x86_64 0:1.42.9-19.el7            e2fsprogs-libs.x86_64 0:1.42.9-19.el7       krb5-libs.x86_64 0:1.15.1-51.el7_9
  libcom_err.x86_64 0:1.42.9-19.el7           libss.x86_64 0:1.42.9-19.el7                openssl.x86_64 1:1.0.2k-24.el7_9
  openssl-libs.x86_64 1:1.0.2k-24.el7_9       zlib.x86_64 0:1.2.7-19.el7_9

Complete!
```
Ну, и собственно, поправить сам spec файл чтобы NGINX собирался с необходимыми нам опциями:

```bash
[root@pack ~]# sed -i 's/--with-debug/--with-openssl=\/root\/openssl-3.0.1/' /root/rpmbuild/SPECS/nginx.spec
```
Теперь соберем RPM пакет:
```bash
[root@pack ~]# rpmbuild -bb rpmbuild/SPECS/nginx.spec
Executing(%prep): /bin/sh -e /var/tmp/rpm-tmp.p8rT4K
+ umask 022
+ cd /root/rpmbuild/BUILD
+ cd /root/rpmbuild/BUILD
+ rm -rf nginx-1.14.1
+ /usr/bin/gzip -dc /root/rpmbuild/SOURCES/nginx-1.14.1.tar.gz
+ /usr/bin/tar -xf -
+ STATUS=0
+ '[' 0 -ne 0 ']'
+ cd nginx-1.14.1
+ /usr/bin/chmod -Rf a+rX,u+w,g-w,o-w .
+ cp /root/rpmbuild/SOURCES/nginx.init.in .
+ sed -e 's|%DEFAULTSTART%|2 3 4 5|g' -e 's|%DEFAULTSTOP%|0 1 6|g' -e 's|%PROVIDES%|nginx|g'
+ sed -e 's|%DEFAULTSTART%||g' -e 's|%DEFAULTSTOP%|0 1 2 3 4 5 6|g' -e 's|%PROVIDES%|nginx-debug|g'
+ exit 0
Executing(%build): /bin/sh -e /var/tmp/rpm-tmp.1lQYjq
+ umask 022
+ cd /root/rpmbuild/BUILD
+ cd nginx-1.14.1
++ echo '--prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module'
+++ pcre-config --cflags
++ echo -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic
+ ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module '--with-cc-opt=-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' '--with-ld-opt=-Wl,-z,relro -Wl,-z,now -pie' --with-openssl=/root/openssl-3.0.1
checking for OS
 + Linux 3.10.0-1127.el7.x86_64 x86_64
checking for C compiler ... not found

./configure: error: C compiler cc is not found

error: Bad exit status from /var/tmp/rpm-tmp.1lQYjq (%build)


RPM build errors:
    Bad exit status from /var/tmp/rpm-tmp.1lQYjq (%build)
```
Чего-то не хватает:
```bash
yum install gcc -y
```
И еще ошибочка
```bash
Can't locate IPC/Cmd.pm in @INC
```
Исправим:
```bash
[root@pack ~]# yum install perl-IPC-Cmd -y
```
И еще разок:
```bash
[root@pack ~]# rpmbuild -bb rpmbuild/SPECS/nginx.spec
```
Опять ошибка:
```bash
Can't locate Data/Dumper.pm in @INC
```
Google говорит, проблемвы с Perl
```bash
[root@pack ~]# yum install -y perl-Data-Dumper
```
и Ошибки
```bash
src/event/ngx_event_openssl.c:4223:9: error: 'ENGINE_free' is deprecated (declared at /root/openssl-3.0.1/.openssl/include/openssl/engine.h:493): Since OpenSSL 3.0 [-Werror=deprecated-declarations]
         ENGINE_free(engine);
```
Попробуем другую версию
```bash
[root@pack ~]# wget https://www.openssl.org/source/openssl-1.1.1m.tar.gz --no-check-certificate
```

```bash
заменим в rpmbuild/SPECS/nginx.spec
--with-openssl=/root/openssl-1.1.1m
[root@pack ~]# rpmbuild -bb rpmbuild/SPECS/nginx.spec
+ umask 022
+ cd /root/rpmbuild/BUILD
+ cd nginx-1.14.1
+ /usr/bin/rm -rf /root/rpmbuild/BUILDROOT/nginx-1.14.1-1.el7_4.ngx.x86_64
+ exit 0
```
Ура, собрался. Убедимся
```bash
[root@pack ~]# ll rpmbuild/RPMS/x86_64/
total 4392
-rw-r--r--. 1 root root 2006396 Feb 22 08:08 nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
-rw-r--r--. 1 root root 2489308 Feb 22 08:08 nginx-debuginfo-1.14.1-1.el7_4.ngx.x86_64.rpm
```

* * *
<a name="3"/>

## Создаем репозиторий
Теперь можно установить наш пакет и убедиться, что nginx работает:
```bash
[root@pack ~]# yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
Loaded plugins: fastestmirror
Examining rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm: 1:nginx-1.14.1-1.el7_4.ngx.x86_64
Marking rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm to be installed
Resolving Dependencies
--> Running transaction check
---> Package nginx.x86_64 1:1.14.1-1.el7_4.ngx will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===================================================================================================================================
 Package             Arch                 Version                             Repository                                      Size
===================================================================================================================================
Installing:
 nginx               x86_64               1:1.14.1-1.el7_4.ngx                /nginx-1.14.1-1.el7_4.ngx.x86_64               5.8 M

Transaction Summary
===================================================================================================================================
Install  1 Package

Total size: 5.8 M
Installed size: 5.8 M
Downloading packages:
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : 1:nginx-1.14.1-1.el7_4.ngx.x86_64                                                                               1/1
----------------------------------------------------------------------

Thanks for using nginx!

Please find the official documentation for nginx here:
* http://nginx.org/en/docs/

Please subscribe to nginx-announce mailing list to get
the most important news about nginx:
* http://nginx.org/en/support.html

Commercial subscriptions for nginx are available on:
* http://nginx.com/products/

----------------------------------------------------------------------
  Verifying  : 1:nginx-1.14.1-1.el7_4.ngx.x86_64                                                                               1/1

Installed:
  nginx.x86_64 1:1.14.1-1.el7_4.ngx

Complete!
```
Запустим, и проверим статус
```bash
[root@pack ~]# systemctl start nginx
[root@pack ~]# systemctl status nginx
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2022-02-22 08:11:11 UTC; 5s ago
     Docs: http://nginx.org/en/docs/
  Process: 3557 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf (code=exited, status=0/SUCCESS)
 Main PID: 3558 (nginx)
   CGroup: /system.slice/nginx.service
           ├─3558 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
           └─3559 nginx: worker process

Feb 22 08:11:10 pack systemd[1]: Starting nginx - high performance web server...
Feb 22 08:11:11 pack systemd[1]: Can't open PID file /var/run/nginx.pid (yet?) after start: No such file or directory
Feb 22 08:11:11 pack systemd[1]: Started nginx - high performance web server.
```
Далее мы будем использовать его для доступа к своему репозиторию.
Теперь приступим к созданию своего репозитория. Директория для статики у NGINX по умолчанию /usr/share/nginx/html. Создадим там каталог repo:
```bash
[root@pack ~]# mkdir /usr/share/nginx/html/repo
```
Копируем туда наш собранный RPM и, например, RPM для установки репозитория
Percona-Server:
```bash
[root@pack ~]# cp rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
[root@pack ~]# wget https://repo.percona.com/yum/percona-release-latest.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-latest.noarch.rpm
--2022-02-22 08:22:49--  https://repo.percona.com/yum/percona-release-latest.noarch.rpm
Resolving repo.percona.com (repo.percona.com)... 141.95.32.160, 142.132.159.91
Connecting to repo.percona.com (repo.percona.com)|141.95.32.160|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 20096 (20K) [application/x-redhat-package-manager]
Saving to: ‘/usr/share/nginx/html/repo/percona-release-latest.noarch.rpm’

100%[=========================================================================================>] 20,096      --.-K/s   in 0s

2022-02-22 08:22:49 (108 MB/s) - ‘/usr/share/nginx/html/repo/percona-release-latest.noarch.rpm’ saved [20096/20096]

```
Инициализируем репозиторий:
```bash
[root@pack ~]# createrepo /usr/share/nginx/html/repo/
Spawning worker 0 with 2 pkgs
Workers Finished
Saving Primary metadata
Saving file lists metadata
Saving other metadata
Generating sqlite DBs
Sqlite DBs complete
```
Для прозрачности настроим в NGINX доступ к листингу каталога: В location / в файле /etc/nginx/conf.d/default.conf добавим директиву autoindex on.
```bash
[root@pack ~]# sed -i '/index  index.html index.htm;/a \\tautoindex on;' /etc/nginx/conf.d/default.conf
```
Перезапустим nginx c проверкой
```bash
[root@pack ~]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@pack ~]# nginx -s reload
```
Посмотрим, на наш репозиторий
```bash
[root@pack ~]# curl -a http://localhost/repo/
<html>
<head><title>Index of /repo/</title></head>
<body bgcolor="white">
<h1>Index of /repo/</h1><hr><pre><a href="../">../</a>
<a href="repodata/">repodata/</a>                                          22-Feb-2022 08:23                   -
<a href="nginx-1.14.1-1.el7_4.ngx.x86_64.rpm">nginx-1.14.1-1.el7_4.ngx.x86_64.rpm</a>                22-Feb-2022 08:14             2006396
<a href="percona-release-latest.noarch.rpm">percona-release-latest.noarch.rpm</a>                  17-Aug-2021 14:59               20096
</pre><hr></body>
</html>

```
Добавим репозиторий в yum
```bash
[root@pack ~]# cat >> /etc/yum.repos.d/otus.repo << EOF
> [otus]
> name=otus-linux
> baseurl=http://localhost/repo
> gpgcheck=0
> enabled=1
> EOF

```
Убедимся, что репозиторий подключился и посмотрим, что в нем есть:
```bash
[root@pack ~]# yum repolist enabled | grep otus
otus                                otus-linux                                 2
```
Так как NGINX у нас уже стоит установим репозиторий percona-release:
```bash
[root@pack ~]# yum install percona-release -y
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.corbina.net
 * extras: mirror.corbina.net
 * updates: mirror.yandex.ru
Resolving Dependencies
--> Running transaction check
---> Package percona-release.noarch 0:1.0-27 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===================================================================================================================================
 Package                               Arch                         Version                       Repository                  Size
===================================================================================================================================
Installing:
 percona-release                       noarch                       1.0-27                        otus                        20 k

Transaction Summary
===================================================================================================================================
Install  1 Package

Total download size: 20 k
Installed size: 32 k
Downloading packages:
percona-release-latest.noarch.rpm                                                                           |  20 kB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : percona-release-1.0-27.noarch                                                                                   1/1
* Enabling the Percona Original repository
<*> All done!
* Enabling the Percona Release repository
<*> All done!
The percona-release package now contains a percona-release script that can enable additional repositories for our newer products.

For example, to enable the Percona Server 8.0 repository use:

  percona-release setup ps80

Note: To avoid conflicts with older product versions, the percona-release setup command may disable our original repository for some products.

For more information, please visit:
  https://www.percona.com/doc/percona-repo-config/percona-release.html

  Verifying  : percona-release-1.0-27.noarch                                                                                   1/1

Installed:
  percona-release.noarch 0:1.0-27

Complete!
```


* * *
<a name="4"/>

## Автоматизация

Составим скрипт для автопробега в Vagrant
```bash
ujack@ubuntu2004:~/linuxpro-homework06$ cat Vagrantfile
# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
        config.vm.box = "centos/7"
        config.vm.box_version = "2004.01"
        config.vm.provider "virtualbox" do |v|
        v.memory = 256
        v.cpus = 1
        end
        config.vm.define "pack" do |pack|
        pack.vm.hostname = "pack"
        pack.vm.provision "shell", path: "pack_script.sh"
        end
end
ujack@ubuntu2004:~/linuxpro-homework06$ cat pack_script.sh
#!/bin/bash
sudo -i
yum install -y redhat-lsb-core wget rpmdevtools rpm-build gcc createrepo yum-utils
cd /root/
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm --no-check-certificate
rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm
wget https://www.openssl.org/source/openssl-1.1.1m.tar.gz --no-check-certificate
tar -xvf openssl-1.1.1m.tar.gz
sed -i 's/--with-debug/--with-openssl=\/root\/openssl-1.1.1m/' /root/rpmbuild/SPECS/nginx.spec
yum-builddep rpmbuild/SPECS/nginx.spec -y
rpmbuild -bb rpmbuild/SPECS/nginx.spec
yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
systemctl start nginx
mkdir /usr/share/nginx/html/repo
cp rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
wget --no-check-certificate https://repo.percona.com/yum/percona-release-latest.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-latest.noarch.rpm
createrepo /usr/share/nginx/html/repo/
sed -i '/index  index.html index.htm;/a \\tautoindex on;' /etc/nginx/conf.d/default.conf
nginx -t
nginx -s reload
curl -a http://localhost/repo/
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF
yum repolist enabled | grep otus
```

* * *
<a name="5"/>

## Проверка
```bash
ujack@ubuntu2004:~/linuxpro-homework06$ vagrant halt
==> pack: Attempting graceful shutdown of VM...
ujack@ubuntu2004:~/linuxpro-homework06$ vagrant destroy
    pack: Are you sure you want to destroy the 'pack' VM? [y/N] y
==> pack: Destroying VM and associated drives...
ujack@ubuntu2004:~/linuxpro-homework06$ vagrant up
...
...
 pack: <html>
    pack: <head><title>Index of /repo/</title></head>
    pack: <body bgcolor="white">
    pack: <h1>Index of /repo/</h1><hr><pre><a href="../">../</a>
    pack: <a href="repodata/">repodata/</a>                                          22-Feb-2022 11:59                   -
    pack: <a href="nginx-1.14.1-1.el7_4.ngx.x86_64.rpm">nginx-1.14.1-1.el7_4.ngx.x86_64.rpm</a>                22-Feb-2022 11:59             2006388
    pack: <a href="percona-release-latest.noarch.rpm">percona-release-latest.noarch.rpm</a>                  17-Aug-2021 14:59               20096
    pack: </pre><hr></body>
    pack: </html>
100   553    0   553    0     0  76614      0 --:--:-- --:--:-- --:--:-- 79000
    pack: otus                                otus-linux                                 2
```
В самом конце видим, WEB Сервер поднят и работет, видно 2 пакета.
Установим percona-release для проверки
```bash
ujack@ubuntu2004:~/linuxpro-homework06$ vagrant ssh
[vagrant@pack ~]$ sudo -i
[root@pack ~]# yum install percona-release -y
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.corbina.net
 * extras: mirror.corbina.net
 * updates: mirror.corbina.net
Resolving Dependencies
--> Running transaction check
---> Package percona-release.noarch 0:1.0-27 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===================================================================================================================================
 Package                               Arch                         Version                       Repository                  Size
===================================================================================================================================
Installing:
 percona-release                       noarch                       1.0-27                        otus                        20 k

Transaction Summary
===================================================================================================================================
Install  1 Package

Total download size: 20 k
Installed size: 32 k
Downloading packages:
percona-release-latest.noarch.rpm                                                                           |  20 kB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : percona-release-1.0-27.noarch                                                                                   1/1
* Enabling the Percona Original repository
<*> All done!
* Enabling the Percona Release repository
<*> All done!
The percona-release package now contains a percona-release script that can enable additional repositories for our newer products.

For example, to enable the Percona Server 8.0 repository use:

  percona-release setup ps80

Note: To avoid conflicts with older product versions, the percona-release setup command may disable our original repository for some products.

For more information, please visit:
  https://www.percona.com/doc/percona-repo-config/percona-release.html

  Verifying  : percona-release-1.0-27.noarch                                                                                   1/1

Installed:
  percona-release.noarch 0:1.0-27

Complete!
```
Done.
