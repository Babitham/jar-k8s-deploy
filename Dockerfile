  
FROM openjdk:8-jre-alpine

RUN mkdir /App

COPY  target/test-1.0.0-SNAPSHOT.jar /App/helloJava.jar

EXPOSE 3333

CMD java -jar /App/helloJava.jar
