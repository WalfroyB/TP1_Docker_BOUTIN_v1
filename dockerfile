# Image de base Ubuntu 16.04 pour compatibilité avec les librairies libjasper1 et libdc1394-22
FROM ubuntu:16.04
# Création de la variable d’environnement pour définir la version de JAVA utilisée
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
# Installation de openjdk-8-jdk, maven, git et des 3 librairies nécessaires à l'application
RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    maven \
    git \
    libpng16-16 \ 
    libjasper1 \
    libdc1394-22 \
 && apt-get autoremove \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* && \
# Récupération sur GitHub des fichiers de l'application
    git clone https://github.com/WalfroyB/TPDockerSampleApp.git
WORKDIR /TPDockerSampleApp
# Création de l'exécutable
RUN mvn install:install-file -Dfile=./lib/opencv-3410.jar \
     -DgroupId=org.opencv  -DartifactId=opencv -Dversion=3.4.10 -Dpackaging=jar && \
    mvn package
# Exposition de l'application sur le port 8080 de la machine hôte (accessible sur navigateur à http://localhost:8080/)
EXPOSE 8080
# Commande finale pour lancer l'application
CMD java -Djava.library.path=lib/ -jar target/fatjar-0.0.1-SNAPSHOT.jar
