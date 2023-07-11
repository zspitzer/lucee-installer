#!/bin/bash
#set -eu

# To recover from failed builds
# rm -rf lucee*jar apache-tomcat-9.0.78.tar.gz OpenJDK11U-jre_x64_linux_hotspot_11.0.19_7.tar.gz jdk-11.0.19+7-jre lucee/tomcat9/tomcat/apache-tomcat-9.0.78 installbuilder-* /tmp/ib


wget https://cdn.lucee.org/lucee-${LUCEE_VERSION}.jar
mv lucee-${LUCEE_VERSION}.jar lucee/lucee/lib/

wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.78/bin/apache-tomcat-9.0.78.tar.gz
cd lucee/tomcat9/
tar zxf ../../apache-tomcat-9.0.78.tar.gz
cd ../..

rm apache-tomcat-9.0.78.tar.gz

mv lucee/tomcat9/apache-tomcat-9.0.78  lucee/tomcat9/tomcat
rm -rf lucee/tomcat9/tomcat/webapps

cp -ar lucee/tomcat9/tomcat-lucee-conf/ lucee/tomcat9/tomcat/

wget https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.19%2B7/OpenJDK11U-jre_x64_linux_hotspot_11.0.19_7.tar.gz
tar zxf OpenJDK11U-jre_x64_linux_hotspot_11.0.19_7.tar.gz 
cp -r jdk-11.0.19+7-jre/* jre/jre64-lin/jre/
rm -rf jdk-11.0.19+7-jre

wget https://releases.installbuilder.com/installbuilder/installbuilder-enterprise-23.4.0-linux-installer.run
chmod a+x ./installbuilder-enterprise-23.4.0-linux-installer.run
./installbuilder-enterprise-23.4.0-linux-installer.run --prefix /tmp/ib --mode unattended

cat lucee/lucee.xml.template | sed -e "s,<version>LUCEE_VERSION</version>,<version>${LUCEE_VERSION}</version>," > lucee/lucee.xml

cd lucee
/tmp/ib/bin/builder quickbuild lucee.xml

echo -n Built 
ls -laht /tmp/ib/output/
/tmp/ib/output/lucee-${LUCEE_VERSION}-linux-x64-installer.run --version
