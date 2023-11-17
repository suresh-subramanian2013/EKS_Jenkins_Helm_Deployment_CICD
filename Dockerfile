FROM: open-jdk-8
ADD target\demo-workshop-2.1.2.jar ttrend.jar
ENTRYPOINT [ "java", "-jar", "ttrend.jar" ]