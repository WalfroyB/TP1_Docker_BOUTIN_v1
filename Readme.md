# Projet ESIR MDI Docker

## How to compile this project

Simple example of using OpenCV in a Web application build using jersey.

This application takes a picture using web browsers camera API (available  in modern browsers) 
and runs OpenCV face recognition algorithm (using [CascadeClassifier](http://docs.opencv.org/java/org/opencv/objdetect/CascadeClassifier.html) ) for it. If a face is detected a "troll face" is added  on top of it.

![Screenshot](/screenshot.png?raw=true "Screenshot")

This application was inspired by the ingenious ["Trollator" mobile Android application](https://play.google.com/store/apps/details?id=com.fredagapps.android.trollator).

1. OpenCV Installation for local Maven repository
---
OpenCV is a native library with Java bindings so you need to install this to your system.
 - *libopencv_java300.so* installed in you java.library.path (
 - *opencv-300.jar* availble for application

There are good instructions how to build OpenCV with Java bindings for your own platform here: http://docs.opencv.org/doc/tutorials/introduction/desktop_java/java_dev_intro.html

Once you have built the Java library you can install the resulting jar file to your local Maven repository using
     mvn install:install-file -Dfile=./bin/opencv-300.jar \
     -DgroupId=org.opencv  -DartifactId=opencv -Dversion=3.0.0 -Dpackaging=jar


2. Building this application
----
Once OpenCV jar library is available as a local Maven dependency, you can clone and build this application simply using Git and Maven:


     mvn install

And run the application using the embedded Jetty plugin in http://localhost:8888

     mvn package
     java -Djava.library.path=/home/barais/git/opencv/build/lib/ -jar target/fatjar-0.0.1-SNAPSHOT.jar
	# Do not forget to update the path to your opencv install in Main.java




If you fork this repo, to be up to date. 

```sh
git remote add upstream https://github.com/barais/projetWE
git fetch upstream
git checkout master
git merge upstream/master
```

