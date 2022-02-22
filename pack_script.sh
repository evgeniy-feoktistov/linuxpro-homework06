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
