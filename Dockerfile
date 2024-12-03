FROM tomcat:9-jdk11

EXPOSE 8080

COPY ./WebContent/WEB-INF/lib/mssql-jdbc-11.2.0.jre11.jar /usr/local/tomcat/lib/mssql-jdbc-11.2.0.jre11.jar

CMD ["catalina.sh", "run"]
