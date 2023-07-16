# 베이스 이미지 설정
FROM openjdk:11
RUN apt update -y
RUN apt install -y wget
RUN wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
RUN tar -xvzf apache-tomcat-9.0.75.tar.gz
RUN mv apache-tomcat-9.0.75 tomcat9
RUN sed -i -r -e '/port 8009/ a\ \    <Connector port="8009" protocol="AJP/1.3" address="0.0.0.0" URIEncoding="UTF-8" secretRequired="false" redirectPort="8443" />' tomcat9/conf/server.xml
RUN echo "ajp test" > tomcat9/webapps/ROOT/index.jsp
WORKDIR /tomcat9/bin
EXPOSE 8080 8009
ENTRYPOINT ["./catalina.sh", "run"]