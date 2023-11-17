FROM: open-jdk-8
ADD libs-release-local/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.4.jar ttrend.jar
ENTRYPOINT [ "java", "-jar", "ttrend.jar" ]