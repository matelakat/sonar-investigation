
sudo tee /etc/apt/sources.list.d/ukmirror.list << EOF
deb http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/ trusty main
deb http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/ trusty universe
deb http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/ trusty multiverse
EOF

sudo apt-get -qy update
sudo DEBIAN_FRONTEND=noninteractive apt-get -qy install mysql-server unzip

mkdir sonar
cd sonar
wget http://dist.sonar.codehaus.org/sonarqube-4.3.zip
unzip sonarqube-4.3.zip
wget https://github.com/SonarSource/sonar-examples/raw/master/scripts/database/mysql/create_database.sql
mysql -u root < create_database.sql

# Copy jre from somewhere
# server-jre-7u60-linux-x64.tar.gz

tar -xzf server-jre-7u60-linux-x64.tar.gz

cp sonarqube-4.3/conf/sonar.properties sonarqube-4.3/conf/sonar.properties.orig

sed -ie '/jdbc:h2/d' sonarqube-4.3/conf/sonar.properties
sed -ie 's/#\(.*jdbc:mysql\)/\1/g' sonarqube-4.3/conf/sonar.properties
sed -ie 's/#wrapper.java.additional.7=-server/wrapper.java.additional.7=-server/g' sonarqube-4.3/conf/wrapper.conf
echo "wrapper.java.additional.7=-Djava.net.preferIPv4Stack=true" >> sonarqube-4.3/conf/wrapper.conf

cp sonarqube-4.3/conf/wrapper.conf sonarqube-4.3/conf/wrapper.conf.orig
sed -ie "s,wrapper.java.command=java,wrapper.java.command=$(readlink -f jdk1.7.0_60/bin/java),g" sonarqube-4.3/conf/wrapper.conf

sonarqube-4.3/bin/linux-x86-64/sonar.sh start

cd
mkdir sonar-runner
cd sonar-runner
wget http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip
unzip sonar-runner-dist-2.4.zip
cp sonar-runner-2.4/conf/sonar-runner.properties sonar-runner-2.4/conf/sonar-runner.properties.orig

tee sonar-runner-2.4/conf/sonar-runner.properties << EOF
sonar.host.url=http://localhost:9000
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar
sonar.login=admin
sonar.password=admin
sonar.jdbc.url=jdbc:mysql://localhost:3306/sonar?useUnicode=true&amp;characterEncoding=utf8
EOF

export SONAR_RUNNER_HOME=$(readlink -f sonar-runner-2.4/)
export PATH=$PATH:$SONAR_RUNNER_HOME/bin:$(readlink -f ../sonar/jdk1.7.0_60/bin/)

cd

sudo apt-get -qy install git
git clone https://github.com/matelakat/sonar-investigation
sonar-investigation/project/java
sonar-runner

# Install cobertura plugin to your sonar
