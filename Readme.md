# Techniques logicielles pour le Cloud Computing - TP1 DOCKER  
:::success  
**Rendre, le fichier dockercompose de l’étape 2 et le docker file de l’étape 3. + Readme.md**  
Date de rendu 24/03 23h59 ferme  
:::  
https://hackmd.diverse-team.fr/s/SJqu5DjSD#  
### 0 - Personnel  
#### Commandes Docker  

``` docker ps ``` Visualiser les conteneurs actifs  
``` docker ps -a ``` Visualiser tous les conteneurs  
``` docker rm [container] ``` Supprimer un conteneur inactif  
``` docker rm -f [container] ``` Forcer la suppression d'un conteneur actif  
``` docker images ``` Lister les images existantes  
``` docker rmi [image] ``` Supprimer une image docker  
``` docker exec -t -i [container] /bin/bash ``` Exécuter des commandes dans un conteneur actif  
``` docker inspect [container] ``` Inspecter la configuration d'un conteneur  
``` docker build -t [image] . ``` Construire une image à partir d'un Dockerfile  
``` docker history [image] ``` Visualiser l'ensemble des couches d'une image  
``` docker logs --tail 5 [container] ``` Visualiser les logs d'un conteneur (les 5 dernières lignes)  
``` docker stop/start [container_ID] ``` stoppe /ou rédemarre  un container actif, sans le supprimer  
``` docker kill [container_ID] ``` tue un container actif.  

#### Interactions avec le registry  
``` docker login ``` Se connecter au registry  
``` docker search [name] ``` Rechercher une image  
``` docker pull [image] ``` Récupérer une image  
``` docker push [image] ``` Pouser une image du cache local au registry  
``` docker tag [UUID] [image]:[tag] ``` Tagger une image  
```sudo docker image ls``` Récupérer informations sur les images, dont le tag.  

#### Commandes Docker Compose  

``` docker-compose up -d ``` Démarre un ensemble de conteneurs en arrière-plan  
``` docker-compose down ``` Stoppe un ensemble de conteneurs  
``` docker-compose exec [service] [command] ``` Exécute une commande au sein d'un service  

#### Autres commandes utiles  
```sudo netstat -lpn | grep 8080``` permet d'identifier le processus qui pourrait tourner sur le port 8080  
``` kill [processus_number]``` tue un processus actif  
```sudo kill -SIGTERM 14779``` tue le processus actif  
```sudo docker run -it --network [nom_du_réseau] nicolaka/netshoot``` outils utiles (à monter sur le même réseau)  
 ```apt-get install -f libpng16-16``` avec -f, --fix-broken
Cette option demande de réparer un système où existent des dépendances défectueuses. Utilisée avec install ou remove, elle peut exclure un paquet pour permettre de déduire une solution viable. Tout paquet spécifié doit complètement corriger le problème. Cette option est quelquefois nécessaire lorsque l'on exécute APT pour la première fois ; APT interdit les dépendances défectueuses dans un système. Il est possible que la structure de dépendances d'un système soit tellement corrompue qu'elle requiert une intervention manuelle (ce qui veut dire la plupart du temps utiliser dpkg --remove pour éliminer les paquets en cause). L'utilisation de cette option conjointement avec -m peut produire une erreur dans certaines situations.


# Etape 1: se familiariser avec Docker  

https://docs.docker.com/get-started/  

![](https://codimd.math.cnrs.fr/uploads/upload_fc8f0cd536295644dde8caebbee5e83b.png)  

### 1.1 - Conteneurisation d'une application

Récupération du dossier ```getting-started```, contenant une application de tye ToDoList, que l'on va containeriser.

- Création de l'image du conteneur, donc création d'un fichier Dockerfile.

    Dans le dossier ```getting-started/app```, j'ouvre un terminal et je rentre la commande:
    ```bash
    touch Dockerfile
    ```
    J'ouvre le fichier Dockerfile pour y insérer le code suivant:
    ```C
    FROM node:18-alpine
    WORKDIR /app
    COPY . .
    RUN yarn install --production
    CMD ["node", "src/index.js"]
    EXPOSE 3000
    ```
    Je recherche et insère la signification des commandes Dockerfile.
    ```C
    # L'instruction FROM permet d’utiliser une image servant de base à la création de notre nouvelle image.
    # L'image se base sur la version linux alpine de Node 18.
    # Alpine Linux = distrib Linux ultra-légère, orientée sécurité conçue pr usage intensif avec sécurité / simplicité / efficacité des ressources
    FROM node:18-alpine

    # WORKDIR définit le répertoire de travail pour toutes les instructions RUN, CMD, ENTRYPOINT, COPY, ADD, etc..., qui le suivent dans le Dockerfile. Si le répertoire n’existe pas, celui-ci sera créé.
    WORKDIR /app

    # COPY = Copie du code source, avec deux arguments <chemin de la source:un répertoire (ou fichier) du host> <chemin de la destination: un répertoire (ou fichier) du conteneur>
    COPY . .

    # RUN permet d’exécuter une commande.
    # yarn install est utilisé pour installer toutes les dépendances d’un projet. Les dépendances sont récupérées depuis le fichier package.json de votre projet, et stockés dans le fichier yarn.lock.
    # --production signifie Installation des dépendances de production uniquement.
    RUN yarn install --production

    # CMD Exécuter une commande au démarrage du conteneur
    CMD [node, src/index.js]

    # EXPOSE = permet de définir les ports d'écoute par défaut, ici PORT 3000
    EXPOSE 3000
    ```
- Construction de l'image du container:

    Dans le dossier ```getting-started/app```, j'ouvre un terminal et je rentre la commande:
    ```
    sudo docker build -t getting-started .
    ```
    Signification:  
    ``` docker build -t ``` Construire une image à partir d'un Dockerfile.  
    ``` getting-started ``` Nom donné à l'image.  
    ``` . ``` Le point signifie qu'il faut aller chercher le Dockerfile dans le fichier courant pour construire l'image docker.  

**Dans le terminal, on voit bien l'exécution des commandes écrites dans le Dockerfile.**  

- Exécution de l'application dans un conteneur:  
```
sudo docker run -dp 3000:3000 getting-started
```
Vérification que le container fonctionne:  
```
docker ps
```
![](https://codimd.math.cnrs.fr/uploads/upload_15771a84a175fa4f42bf96c16c6742c9.png)

Ouverture du lien http://localhost:3000/ . L'application tourne bien sur le port 3000.

![](https://codimd.math.cnrs.fr/uploads/upload_bec9d592bcaba51becab8aea5f2bd907.png)

### 1.2 - Mise à jour de l'application containeurisée  

Je vais changer la phrase d'accueil de l'application dans ```src/static/js/app.js```, à la ligne 56.  

Je réalise à nouveau les étapes suivantes:  
- Construction de l'image du container:  
```
sudo docker build -t getting-started .
```
- Exécution de l'application dans un nouveau conteneur:  
```
sudo docker run -dp 3000:3000 getting-started
```
J'obtiens une erreur:  
![](https://codimd.math.cnrs.fr/uploads/upload_029e747682d9abc5cd2142f26d56a238.png)
Le port 3000 est pris par le premier conteneur, je dois donc le supprimer.  

### 1.3 - Suppression d'un conteneur  

Je dois trouver l'ID du conteneur à supprimer:  
```
sudo docker ps
```
![](https://codimd.math.cnrs.fr/uploads/upload_3503d566c72d6fa034797c82bbbad317.png)

L'ID de mon premier conteneur est **8091bc9bd920.**  

Je stoppe ce conteneur:  
```
sudo docker stop 8091bc9bd920  
```
Je supprime ce conteneur:  
```
sudo docker rm 8091bc9bd920
```
**NB: je peux stopper et supprimer le conteneur en une seule commande:**  
```sudo docker rm -f 8091bc9bd920```

Je vérifie que le conteneur est bien supprimé:  
```
sudo docker ps
```
![](https://codimd.math.cnrs.fr/uploads/upload_545e4ed8841e8ab6e335c58a1cc678ec.png)

Je peux maintenant effectuer l'exécution de mon apllication MàJ dans un conteneur, puisque le port 3000 est libéré:  
```
sudo docker run -dp 3000:3000 getting-started
```
Vérification avec ```sudo docker ps```:  
![](https://codimd.math.cnrs.fr/uploads/upload_f343fe47e64cc8b827dd75df620de6d5.png)

L'ID de mon nouveau conteneur est **a6423b34b2b1.**  

Sur mon port 3000, http://localhost:3000/ , le message de bienvenue a bien été mis à jour, **mais les tâches rentrées dans l'application ont été supprimées.**  
![](https://codimd.math.cnrs.fr/uploads/upload_232603089ec78e17485dbdaa23efddda.png)

### 1.4 - Partager l'application  

Pour partager des images Docker, on doit utiliser un registre Docker. Le registre par défaut est Docker Hub.  

- Création d'un dépôt ```walfvonfroy/getting-started``` dans Docker Hub:  
https://hub.docker.com/repository/docker/walfvonfroy/getting-started  

- Vérification de mes images Docker disponibles:  

    ```sudo docker image ls```

    ![](https://codimd.math.cnrs.fr/uploads/upload_466b958e14aa13ec7e1cc9c0665eb32b.png)

- Connection à mon référentiel dans Docker Hub.   
    
    ``` sudo docker login -u walfvonfroy```

    ![](https://codimd.math.cnrs.fr/uploads/upload_6713963da99461d34534622a5454ee75.png)

- Création d'une étiquette (tag) dans ce dépôt Docker Hub:  
    
    ```sudo docker tag getting-started walfvonfroy/getting-started```

    NB: par défaut, dans Docker Hub, j'aurai une étiquette par défaut nommée ```latest```.  
 
- Pousser l'image dans Docker Hub:  

    ```sudo docker push walfvonfroy/getting-started```

    ![](https://codimd.math.cnrs.fr/uploads/upload_78788a2e0da522c9db966b2c45aaa0ab.png)

  Je retrouve mon étiquette ```latest``` + image dans Docker Hub.  
  
    ![](https://codimd.math.cnrs.fr/uploads/upload_271f57ceaa99bceb1f7502427803ee2e.png)

    Pour pousser l'image dans Docker Hub avec une étiquette de mon choix ```Image_001_TP_Docker``` par exemple, je rentre en ligne de commande:  

    ```
    sudo docker tag getting-started walfvonfroy/getting-started:Image_001_TP_Docker
    ```   
    ```
    sudo docker push walfvonfroy/getting-started:Image_001_TP_Docker
    ```  
    Je retrouve mon étiquette personnalisée + image dans Docker Hub.  
    
![](https://codimd.math.cnrs.fr/uploads/upload_245f7546550c8b29fc1a540437fbe8dd.png)

- Exécution de l'image sur une nouvelle instance avec https://labs.play-with-docker.com :  

J'ajoute une instance et je tape la commande suivante dans le terminal de Play with Docker, pour exécuter l'application:  

```
docker run -dp 3000:3000 walfvonfroy/getting-started
```  
L'image se déroule et démarre.  

![](https://codimd.math.cnrs.fr/uploads/upload_50a417abc958233131c9b160c92bbc23.png)

Sur la page de Play with Docker, cliquer sur le bouton **3000** et on obtient notre application dans notre navigateur.

![](https://codimd.math.cnrs.fr/uploads/upload_389a2303053cf683794414f159b51438.png)

Cependant, si je rentre quelques tâches dans mon application, que je la ferme, puis que je relance mon image dans Docker Hub, je retrouve mon application sur le port 3000, mais les tâches n'ont pas été enregistrées.



### 1.5 - Persistance de la base de données
https://docs.docker.com/get-started/05_persisting_data/

#### 1.5.1 - Petite expérience
Nous allons démarrer deux conteneurs et créer un fichier dans chacun. Ce que nous allons voir, c'est que les fichiers créés dans un conteneur ne sont pas disponibles dans un autre.  

Je lance un conteneur ubuntu avec un fichier data.txt, qui va contenir un chiffre entre 1 et 10 000.  
```
sudo docker run -d ubuntu bash -c "shuf -i 1-10000 -n 1 -o /data.txt && tail -f /dev/null"
```
```
sudo docker ps
```
Mon conteneur ID = 990ecbcc057e  

J'ouvre le fichier data.txt.  
```
sudo docker exec 990ecbcc057e cat /data.txt
```
![](https://codimd.math.cnrs.fr/uploads/upload_baef957043fe479f1ca6571a03ede621.png)

Dans le data.txt du premier conteneur, j'ai le chiffre 5903.  

Je lance maintenant un deuxième conteneur ubuntu:  
```
sudo docker run -d ubuntu bash -c "shuf -i 1-10000 -n 1 -o /data.txt && tail -f /dev/null"
```
```
sudo docker ps
```
Mon ID pour le 2ème ubuntu = 4563dde29491.  
![](https://codimd.math.cnrs.fr/uploads/upload_3a7ee166a0ddadef27dc6b9a61c4030f.png)
Dans le data.txt du 2ème conteneur, j'ai le chiffre 8978.  

CCL: les fichiers data.txt n'ont pas les mêmes contenus.  

Je supprime le 1er conteneur:  
```sudo docker rm -f 990ecbcc057e```


#### 1.5.2 - Travail sur les volumes nommés  
Les volumes permettent de connecter des chemins de système de fichiers spécifiques du conteneur à la machine hôte.  

Les volumes nommés sont parfaits si nous voulons simplement stocker des données, sans se préoccuper d'où elles se trouvent.  

:::info  
Commande ```-v``` se compose de trois champs, séparés par des caractères deux-points (:).   
Dans le cas de volumes nommés, le premier champ est le **nom du volume** et est **unique sur une machine hôte donnée**. Pour les volumes anonymes, le premier champ est omis.  
Le deuxième champ est le **chemin où le fichier ou le répertoire sont montés dans le conteneur**.   
Le troisième champ est facultatif et est une liste d'options séparées par des virgules, telles que ro.  
:::  

Je crée un volume nommé ```todo-db``` dans ```/docker``` de ma machine:  
```
sudo docker volume create todo-db
```  
Je supprime mon conteneur ```getting-started``` contenant l'application ToDoList:  
```sudo docker ps```  
```sudo docker rm -f a6423b34b2b1```  

Je relance un conteneur, en mentionnant ```-v```, i.e. je crée un volume entre  ```todo-db``` de ma machine et ```/etc/todos``` dans mon conteneur.  
```
sudo docker run -dp 3000:3000 -v todo-db:/etc/todos getting-started
```  
Mon numéro de conteneur est **53c3e9d8c0d0**.  

J'ouvre mon application: http://localhost:3000/ et je rajoute des tâches.  
![](https://codimd.math.cnrs.fr/uploads/upload_32c55fdb43880f70bbddceaee8c70e3b.png)

Maintenant, je supprime mon conteneur **53c3e9d8c0d0**.  
```sudo docker rm -f 53c3e9d8c0d0```  

Je relance un nouveau conteneur pour mon application:  
```
sudo docker run -dp 3000:3000 -v todo-db:/etc/todos getting-started
```  

CCL: mon application ToDoList fonctionne avec les données enregistrées, grâce au volume nommé ```todo-db``` situé dans ma machine et qui a mis à jour ```/etc/todos``` de mon nouveau conteneur.  

Je peux aller inspecter mon volume nommé:  
```sudo docker volume inspect todo-db```  

![](https://codimd.math.cnrs.fr/uploads/upload_3e45c3215adea447cc54ef7d54cb6a7c.png)

:::info  
La reconstruction des images pour chaque modification prend un peu de temps avec les volumes nommés. Nous allons voir un meilleur moyen avec les montures liées.  
:::  


### 1.6 - Travail sur les montures liées (bind mount):  

https://docs.docker.com/get-started/06_bind_mounts/  

Avec les montages liés, nous contrôlons le point de montage exact sur l'hôte. Je conserve mes données, je peux y accéder, les modifier et les remonter sur le conteneur.

![](https://codimd.math.cnrs.fr/uploads/upload_5fa09fc802590c4b0d72d6b08e2e0d6b.png)

Je stop/supprime mon conteneur puis je supprime mon volume nommé.
```sudo docker rm -f 323f0dbcfaea```
```sudo docker volume rm todo-db```

Je relance un conteneur avec un montage lié vers ```/home/walfroy```:
```
sudo docker run -dp 3000:3000 -v /home/walfroy:/etc/todos getting-started
```
![](https://codimd.math.cnrs.fr/uploads/upload_71c9f35f3149265534c6407b0140fae7.png)

Je vais regarder les propriétés de mon fichier ```todo.db```.
![](https://codimd.math.cnrs.fr/uploads/upload_78c7d414f72e72fda3813f22c580dddd.png)

J'ouvre mon application et rajoute des tâches. En faisant à nouveau ```ls -l``` je constate que l'heure de modification de mon fichier ```todo.db``` est passé de **18h55 à 19h18**, heure à laquelle j'ai ajouté mes tâches.  
![](https://codimd.math.cnrs.fr/uploads/upload_66d0da079dc43752285a5726340516c8.png)
Pour accéder à un fichier ```.db```, je dois installer Sqlite3.  
![](https://codimd.math.cnrs.fr/uploads/upload_75a184ec62013e63c5518297394f2589.png)

:::info  
Je cherche à accéder aux données de ```todo.db```:
![](https://codimd.math.cnrs.fr/uploads/upload_44081ad87a3d2a585d6a29196ea76106.png)

Je charge ma BdD ```todo.db``` dans un fichier ```tododb.txt```
```
sqlite3 todo.db .dump > tododb.txt
```
Puis je vais consulter le fichier ```tododb.txt```.
```
cat -n tododb.txt
```
![](https://codimd.math.cnrs.fr/uploads/upload_1ff1fdb10aad5403eda2e64bcc48b1e0.png)

Je peux modifier les données de ce fichier ```tododb.txt```, en modififant directement sur le fichier ```tododb.txt``` ou en utilisant la ligne de commande ```sudo nano tododb.txt```.

Je peux charger mon fichier ```tododb.txt``` vers ma BdD ```todo.db``` avec :
```
sqlite3 todo.db < tododb.txt
```  

Problème: ça charge bien dans ```todo.db```, mais ça n'écrit pas sur les anciennes données, ça les rajoute à la suite (voir ce problème plus tard).  

:::warning  
Je peux charger ma BdD dans autre chose qu'un fichier```.txt```. Ce peut être un fichier```.sql``` par exemple.  
:::  


Reprise le 03/02/2023 - il semble que le site a changé d'exemple à suivre.   

**Trying out bind mounts** https://docs.docker.com/get-started/06_bind_mounts/  

Dans mon répertoire ```getting-started/app```, je lance la commande:  
```
docker run -it --mount type=bind,src="$(pwd)",target=/src ubuntu bash
```  
:::info  
Je démarrer un ```bash``` dans un ```ubuntu```avec un montage de liaison ```--mount type=bind``` entre le répertoire actuel de travail ```src="$(pwd)"``` et la cible qui l'endroit où ce réperoire doit apparaître dans le conteneur ```target=/src```.  

```-i``` : garde STDIN (STanDard INput, flux standard pour l'entrée standard/clavier) ouvert, même si pas attaché ;  
```-t``` : alloue un pseudo-terminal  
:::  

![](https://codimd.math.cnrs.fr/uploads/upload_02153f8856b1585f1db84cc3d37f8998.png)

Docker démarre une session bash dans le répertoire racine du système de fichiers du conteneur.  
Pour s'en assurer, on peut taper la commande ```pwd``` (print working directory), puis ```ls``` pour visualiser ce qu'il y a la racine du conteneur :   
![](https://codimd.math.cnrs.fr/uploads/upload_d7a6eb256119666685ffc34dba254604.png)

Je peux aller observer le répertoire ```src```, qui est le répertoire que j'ai monté lorsque j'ai lancé le conteneur. Je vais y retrouver les mêmes éléments que j'ai sur ma machine hôte à ```getting-started/app```.  
![](https://codimd.math.cnrs.fr/uploads/upload_51c87b789f1ee16b38c2d14d788934fd.png)

Je vais maintenant créer dans mon conteneur un fichier ```myfile.txt```, et je vais observer que sur ma machine hôte, je retrouve le même fichier : 
![](https://codimd.math.cnrs.fr/uploads/upload_f8b1a40e6adddd7a9e11c4b52c01c6e6.png)

En supprimant le ```myfile.txt``` de ma machine hôte, j'observe qu'il est également supprimé de mon conteneur:  
![](https://codimd.math.cnrs.fr/uploads/upload_ea03d2386df049e0238f77d4ea396e87.png)

Je stoppe la session interactive avec le conteneur, en utilisant **CTRL+D**.  

#### 1.5.4 - Exécuter l'application dans un conteneur de développement  

Les étapes suivantes décrivent comment exécuter un conteneur de développement avec une monture liée qui réalise :   

- le montage du code source dans le conteneur ;  
- l'installation de toutes les dépendances, y compris les dépendances "dev" ;  
- le démarrage de ```nodemon``` pour surveiller les modifications du système de fichiers.  

Je supprime mes conteneurs actifs :  
```sudo docker ps```  
```sudo docker rm -f XXXXXXXXXXXX```  

Je lance, depuis le répertoire /app:  
```
sudo docker run -dp 3000:3000 \
     -w /app -v "$(pwd):/app" \
     node:18-alpine \
     sh -c "yarn install && yarn run dev"
```  
```docker run -dp 3000:3000```: j'exécute mon docker en mode détaché (arrière-plan) et créer un mappage de port sur le port 3000 ;

```-w /app``` définit le "répertoire de travail" ou le répertoire actuel à partir duquel la commande sera exécutée ;

```-v "$(pwd):/app"``` effectue une monture liée (bind mount) du répertoire courant de l'hôte dans le répertoire /app du conteneur ;

```node:18-alpine``` - l'image à utiliser. Notez qu'il s'agit de l'image de base de notre application à partir du Dockerfile ;

```sh``` démarrer un shell car Alpine n'a pas de bash ;

```"yarn install && yarn run dev"```: exécuter ```yarn install``` pour installer toutes les dépendances, puis exécuter ```yarn run dev```.

**Info**: Yarn est un nouveau gestionnaire de dépendances pour NodeJS.

![](https://codimd.math.cnrs.fr/uploads/upload_60fd5cf58f2010f104b7cb1d56206c3b.png)


Si nous regardons dans le ```package.json```, nous verrons que le script de développement démarre ```nodemon``` : 
![](https://codimd.math.cnrs.fr/uploads/upload_5a97687726cb6d994b15e0c065a2928e.png)


On peut regarder le journal docker:
```sudo docker logs -f 6c4e72939ecf```.

![](https://codimd.math.cnrs.fr/uploads/upload_7cec6e2f06b86d34e105bd00539b4b7c.png)
**CTRL + C** pour quitter.  

Je teste mon application http://localhost:3000/ 
![](https://codimd.math.cnrs.fr/uploads/upload_541de4d8ba74b02a5d72ff05f47324dd.png)

Je vais, sur ma machine hôte, et je change ```src/static/js/app.js```, à la ligne 109 la mention **Add Item** en **Ajouter un élément**. Lorsque j'actualise ma page, la modification est bien prise en compte : 
![](https://codimd.math.cnrs.fr/uploads/upload_c26ce9d76c2e0b15f3093125c5190883.png)

:::success    
**IMPORTANT**:    
Chaque fois que je fais une modification sur ma machine hôte et que j'enregistre le fichier modifié, le processus **nodemon** redémarre l'application à l'intérieur du conteneur automatiquement (petit délai possible avant MàJ).   
:::    

NOTES : L'utilisation de montages liés est courante pour les configurations de développement local. L'avantage est que la machine de développement n'a pas besoin d'avoir tous les outils de construction et environnements installés.   
En plus des montages de volume et des montages de liaison, Docker prend également en charge d'autres montages types et pilotes de stockage pour gérer des cas d'utilisation plus complexes et spécialisés. Pour en savoir plus sur les concepts de stockage avancés, voir https://docs.docker.com/storage/  

### 1.7 Applications multi-conteneurs  
https://docs.docker.com/get-started/07_multi_container/  

Jusqu'à présent, nous travaillions avec des applications à conteneur unique. Mais, nous voulons maintenant ajouter MySQL à la pile d'applications.   

**Rappel**: en général, **chaque conteneur doit faire une chose et le faire bien**.  

Je mets à jour l'application pour qu'elle fonctionne comme ceci :  
![](https://codimd.math.cnrs.fr/uploads/upload_6919f30cfa518b2c6410ecbdc06a6c52.png)

Note: Si deux conteneurs sont sur le même réseau, ils peuvent communiquer entre eux. S'ils ne le sont pas, ils ne peuvent pas.  

**Je démarre MySQL**  
:::info  
MySQL est la base de données open source la plus populaire au monde. Avec ses performances éprouvées, sa fiabilité et sa facilité d'utilisation, MySQL est devenu le premier choix de base de données pour les applications Web, couvrant toute la gamme des projets personnels et des sites Web  
:::  
Il existe deux manières de mettre un conteneur sur un réseau :  
1) l'affecter au démarrage ;  
2) ou y connecter un conteneur existant.  

Pour l'instant, on effectue la 2ème méthode : 

Création d'un réseau ```todo-app```:  
```sudo docker network create todo-app```  

Démarrage d'un conteneur MySQL avec attachement au réseau (voir la section "Variables d'environnement" dans https://hub.docker.com/_/mysql/) :  
```
docker run -d \
     --network todo-app --network-alias mysql \
     -v todo-mysql-data:/var/lib/mysql \
     -e MYSQL_ROOT_PASSWORD=secret \
     -e MYSQL_DATABASE=todos \
     mysql:8.0
```  

:::info  
```--network todo-app``` j'attribue le conteneur au réseau todo-app;  
```--network-alias mysql``` je dis que **mysql** est l'alias de réseau de ma base de données;  
J'utilise un volume nommé ```todo-mysql-data```monté à ```/var/lib/mysql```, où MySQL stocke ses données. Docker reconnaît que nous voulons utiliser un volume nommé et en crée un automatiquement pour nous;  
```secret``` est le mot de passe à définir pour l'utilisateur root de MySQL;  
```todos``` est le nom de la base de données;  
```8.0``` est la balise spécifiant la version de MySQL souhaitée.   
:::  
![](https://codimd.math.cnrs.fr/uploads/upload_73a09d28e9e76386275fa33e993075fa.png)

Pour confirmer que la base de données est opérationnelle, et je me connecte à la base de données et j'en vérifie la connection :  
```
sudo docker ps #pour récupération du container ID
```  
```
sudo docker exec -it 6ff105bbad08 mysql -u root -p
```  
![](https://codimd.math.cnrs.fr/uploads/upload_7aa9567bf8fbbc8d73d0259b2a06eead.png)

Dans le *shell mysql*, je vérifie les bases de données qu'elle contient avec ```SHOW DATABASES;```. Il y a bien ma base de données **todos**.  
![](https://codimd.math.cnrs.fr/uploads/upload_1b29af9f771c44b3695b7865c9cde4eb.png)

**Je connecte mon Application *Todo App* à MySQL**  

Maintenant que je sais que MySQL est opérationnel, je vais l'utiliser ! Mais, la question est... comment ? Si je lance un autre conteneur sur le même réseau, comment trouver le conteneur (chaque conteneur a sa propre adresse IP !)?   

Pour le comprendre, je vais utiliser le conteneur **nicolaka/netshoot** , qui est livré avec de nombreux outils utiles pour le dépannage ou le débogage des problèmes de réseau.   

1-Je démarre un nouveau conteneur en utilisant l'image [**nicolaka/netshoot**](https://github.com/nicolaka/netshoot). Je m'assure de le connecter au même réseau.  
```
sudo docker run -it --network todo-app nicolaka/netshoot
```  

![](https://codimd.math.cnrs.fr/uploads/upload_e55a848c697f798dfa8276ccbf50ffb2.png)

2-A l'intérieur du conteneur, je vais utiliser la commande ```dig```, qui est un outil DNS utile. Je cherche l'adresse IP pour le nom d'hôte **mysql**.   
```
dig mysql
```  
![](https://codimd.math.cnrs.fr/uploads/upload_3715383203271dafe185259c72fdbf3d.png)

Sous la ligne ANSWER SECTION, on retrouve l'alias de réseau de ma base de données ***mysql*** relié à l'adresse IP **172.18.0.2**.  

**Conséquence**: l'application n'a qu'à se connecter à un hôte nommé ***mysql*** et elle communiquera avec la base de données via cet alias.  

**J'exécute l'application avec MySQL**  

1-Pour MySQL versions 8.0 et au-dessus, inclure les commandes suivantes dans mysql:  
```
# Je me connecte à mysql (mot de passe = secret)
sudo docker exec -it 6ff105bbad08 mysql -u root -p
```
```
# J'inclus les commandes dans mysql 8.0 et plus
ALTER USER 'root' IDENTIFIED WITH mysql_native_password BY 'secret';
flush privileges;
```  
![](https://codimd.math.cnrs.fr/uploads/upload_fe4b93ded1b9618c20f72623fbb73ffe.png)

2-Je lance le conteneur avec les commandes suivantes:  
```
sudo docker run -dp 3000:3000 \
   -w /app -v "$(pwd):/app" \
   --network todo-app \
   -e MYSQL_HOST=mysql \
   -e MYSQL_USER=root \
   -e MYSQL_PASSWORD=secret \
   -e MYSQL_DB=todos \
   node:18-alpine \
   sh -c "yarn install && yarn run dev"
```  

3-J'examine le journal de logs du conteneur:   
```
sudo docker ps
```  
```
sudo docker logs -f 379c13ec565b
```  
![](https://codimd.math.cnrs.fr/uploads/upload_0db531f63b71a2451ac363564eb3df7c.png)

On voit l'indication que le conteneur est connecté à l'hôte ***mysql***  


4-J'ouvre l'application http://localhost:3000/ dans mon navigateur, j'y inclue quelques tâches : 
![](https://codimd.math.cnrs.fr/uploads/upload_879f183bdb1cb519b7d313eca03d92cf.png)

5-Je me connecte à la base de données mysql pour vérifier que les 4 tâches sont bien dedans :   
```
sudo docker exec -it 6ff105bbad08 mysql -p todos
```  
```
select * from todo_items;
```  
**Les 4 tâches rentrées dans l'application sont bien incrémentées dans la base de données.**  

![](https://codimd.math.cnrs.fr/uploads/upload_9a84a10ce3c58d4933e71b94b0e0eae9.png)

Résumé: je dois créer un réseau, démarrer des conteneurs, spécifier toutes les variables d'environnement, exposer ports, etc ... C'est compliqué à retenir. Je vais donc simplifier ça grâce au Docker Compose.  


### 1.8 - Utilisation de Docker Compose  
https://docs.docker.com/get-started/08_using_compose/  
:::info  
Docker Compose est un outil qui a été développé pour aider à définir et partager des applications multi-conteneurs. Avec Compose, nous pouvons créer un fichier YAML pour définir les services et avec une seule commande, nous pouvons tout faire tourner ou tout détruire.  

Le gros avantage de l'utilisation de Compose est que vous pouvez définir votre pile d'applications dans un fichier, la conserver à la racine de votre référentiel de projet (il est désormais contrôlé par version) et permettre facilement à quelqu'un d'autre de contribuer à votre projet. Quelqu'un aurait seulement besoin de cloner votre référentiel et de démarrer l'application de composition.  
:::  

Vérifier l'installation et les informations de version de Docker Compose (v2.15.1):  
```  
docker compose version
```  

![](https://codimd.math.cnrs.fr/uploads/upload_8c2daaa71e225627302b5d6fb17cd186.png)

**Créer le fichier Compose**  

**Pré-requis / installations**:  
Installer npm et Yarn + vérification version de Yarn (1.22.19)compose:  
```
sudo apt install npm
```  
```
sudo npm install --global yarn
```  
```
sudo apt update && sudo apt install yarn
```  
```
yarn --version
```  
```
sudo apt  install docker-compose
```  
À la racine du projet d'application, créez un fichier nommé ```docker-compose.yml```.  
```
touch docker-compose.yml
```  
Dans ce fichier, je vais définir la liste des services (ou conteneurs) que je souhaite exécuter dans le cadre de mon application.  
Pour celà, je rajoute une ligne service:  
```bash
echo "services:" >> docker-compose.yml

```  
![](https://codimd.math.cnrs.fr/uploads/upload_b69c677c7559b2e3fde95c818b834873.png)

**Définir le service d'application**  

Pour rappel, voici la commande précédemmment utilisée pour définir mon conteneur d'application sur https://docs.docker.com/get-started/07_multi_container/  

```bash
sudo docker run -dp 3000:3000 \
  -w /app -v "$(pwd):/app" \
  --network todo-app \
  -e MYSQL_HOST=mysql \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=secret \
  -e MYSQL_DB=todos \
  node:18-alpine \
  sh -c "yarn install && yarn run dev"
```  
Et bien, maintenant on va écrire cela dans le DockerCompose:  

1-Je commence par définir l'entrée de service et l'image du conteneur. Je peux choisir n'importe quel nom pour le service. Le nom deviendra automatiquement un alias réseau, ce qui sera utile lors de la définition de mon service MySQL.   
```YAML
services:
  # The app service definition
  app:
    image: node:18-alpine
    command: sh -c "yarn install && yarn run dev"
```  
2-Je migre le ```-p 3000:3000``` en définissant le ```ports``` pour le service. J'utilise la [syntaxe courte](https://docs.docker.com/compose/compose-file/compose-file-v3/#short-syntax-1) ici en spécifiant les deux ports (HOST:CONTAINER) sous forme de chaines, mais il y a aussi une [syntaxe plus verbeuse et longue](https://docs.docker.com/compose/compose-file/compose-file-v3/#long-syntax-1) également possible.   
```YAML
services:
  # The app service definition
  app:
    image: node:18-alpine
    command: sh -c "yarn install && yarn run dev"
    ports:
      - "3000:3000"
```
ou
```YAML
services:
  # The app service definition
  app:
    image: node:18-alpine
    command: sh -c "yarn install && yarn run dev"
    ports:
      - target: 3000 #le port à l'intérieur du conteneur 
      published: 3000 #le port exposé publiquement 
      protocol: tcp #le protocole du port ( tcp/udp) 
      mode: host #host, pour publier un port hôte sur chaque nœud, ou ingress, pour un essaim port de mode à charge équilibrée. 
```  
3-Ensuite, je migre à la fois le répertoire de travail ```( -w /app)``` et le mappage de volume ```( -v "$(pwd):/app")``` en utilisant le ```working_dir``` et ```volumes```. Les volumes ont également une synthaxe [courte](https://docs.docker.com/compose/compose-file/compose-file-v3/#short-syntax-3) et une [longue](https://docs.docker.com/compose/compose-file/compose-file-v3/#long-syntax-3).  

L'un des avantages des définitions de volume Docker Compose est que je peux utiliser des chemins relatifs à partir du répertoire actuel.   
```YAML
services:
  # The app service definition
  app:
    image: node:18-alpine
    command: sh -c "yarn install && yarn run dev"
    ports:
      - target: 3000
      published: 3000 
      protocol: tcp
      mode: host
    working_dir: /app
    volumes:
      - ./:/app
```  
4-Enfin, je migre les définitions des variables d'environnement à l'aide du mot clé ```environment```:  
```YAML
services:
  # The app service definition 
  app:
    image: node:18-alpine
    command: sh -c "yarn install && yarn run dev"
    ports:
      - target: 3000
      published: 3000 
      protocol: tcp
      mode: host
    working_dir: /app
    volumes:
      - ./:/app
    environment:
      MYSQL_HOST: mysql
      MYSQL_USER: root
      MYSQL_PASSWORD: secret
      MYSQL_DB: todos
```  

**Définir le service MySQL**  

Pour mémoire, la commande Docker utilisée était:  
```bash
docker run -d \
  --network todo-app --network-alias mysql \
  -v todo-mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=todos \
  mysql:8.0
```  
La traduction en format YAML pour le Docker Compose va se faire ainsi:  

1- Je définis d'abord définir le nouveau service que j'appelle ```mysql``` il obtient donc automatiquement l'alias réseau. Je spécifie également l'image à utiliser.   
```YAML
services:
  # The app service definition 
  app:
  #The MySQL service definition
  mysql:
    image: mysql:8.0
```  
2-Je définis les volumes. Lors de l'exécution du conteneur avec ```docker run```, le volume nommé a été créé automatiquement. Cependant, cela ne se produit pas lors de l'exécution avec Compose. Je dois définir le volume au niveau supérieur  ```volumes:``` puis spécifiez le point de montage dans la configuration du service. En fournissant simplement le nom du volume, les options par défaut sont utilisées. Il existe une [version longue](https://docs.docker.com/compose/compose-file/compose-file-v3/#volume-configuration-reference) avec de nombreuses options .   
```YAML
services:
  # The app service definition 
  app:
  #The MySQL service definition
  mysql:
    image: mysql:8.0
    volumes:
      - todo-mysql-data:/var/lib/mysql

volumes:
  todo-mysql-data:
```  
3-Enfin, je spécifie dans le service MySQL, les variables d'environnement:  
```YAML
services:
  # The app service definition 
  app:
  #The MySQL service definition
  mysql:
    image: mysql:8.0
    volumes:
      - todo-mysql-data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: todos

volumes:
  todo-mysql-data:
```  

Mon fichier ```docker-compose.yml``` ressemble donc à:  
![](https://codimd.math.cnrs.fr/uploads/upload_486216e561f60fc595b731ce94792b34.png)

NB: il n'y a pas besoin de définir de réseau (```-- network```), puisque Docker Compose va le faire automatiquement.  

Je peux démarrer mon ```docker compose``` avec la commande:  
```
sudo docker compose up -d #(-d) signifie en arrière-plan
```  
![](https://codimd.math.cnrs.fr/uploads/upload_c72a1ce9db65af64b5950049f6b0e199.png)

On remarque que Docker Compose lance automatiquement :   
- la création d'un réseau ;  
- la création d'un volume ;  
- un conteneur pour l'application ;  
- un conteneur pour ma base de données.  

Je lance mon application http://localhost:3000/ dans mon navigateur et rentre quelques tâches:  
![](https://codimd.math.cnrs.fr/uploads/upload_5d0867636943be0ddb8779bbb32be111.png)

J'effectue quelques vérifications:  
```bash
docker compose logs -f #Je peux rajouter le nom du service sur lequel je veux des informations.
```  
![](https://codimd.math.cnrs.fr/uploads/upload_155aff1729fedb94f926a5bcdb48233a.png)


Une commande ```sudo docker ps``` nous permet de voir nos deux conteneurs tourner: celui de la base de données et celui de l'application.  

![](https://codimd.math.cnrs.fr/uploads/upload_3bbf1e0e0d3f507afe540ab813ba8755.png)

# FIN ETAPE 1  

# Etape 2: LoadBalancer with Docker + une image docker pour vos applications  
https://github.com/barais/TPDockerSampleApp/  

Vérification d'installation de Docker:  
```sudo docker run hello-world```  
Lancement d'une machine Ubuntu conteneurisée, avec le bash:  
```sudo docker run -t -i ubuntu /bin/bash```  

Dans le shell de cette machine Ubuntu:  
```
apt-get update
apt-get install net-tools
/sbin/ifconfig
```  
On remarque que l'interface réseau n'est pas la même pour le conteneur Ubuntu  - le conteneur vient avec sa propre interface réseau - que pour ma machine physique:  
![](https://codimd.math.cnrs.fr/uploads/upload_a91ed77d3a8874d60ab9638b45265302.png)  
*Interface réseau conteneur Ubuntu*    

## Etape 2.1 (si vous utilisez docker sur votre machine ou à l'ISTIC): Jouons avec docker: mise en place d'un load balancer et d'un reverse proxy avec docker et nginx    

**Notes personnelles**:    
- un load balancer est un outil de répartition de charge (en anglais : load balancing). Celà désigne le processus de répartition d’un ensemble de tâches sur un ensemble de ressources, dans le but d’en rendre le traitement global plus efficace. Les techniques de répartition de charge permettent à la fois d’optimiser le temps de réponse pour chaque tâche, tout en évitant de surcharger de manière inégale les nœuds de calcul.    

Le [Load-Balancing](https://www.it-connect.fr/reverse-proxy-nginx-load-balancing-et-fail-over/) est le fait de répartir les requêtes qui arrivent sur un service entre plusieurs serveurs (deux ou plus). On peut alors avoir une diminution de la charge de travail des serveurs gérés en Load-Balancing ce qui permet d'éviter les surcharges, des ralentissements et des plantages. Un Load-balancing requiert le plus souvent un hôte dit "front-end" dont le rôle va être de réceptionner les requêtes et de les répartir entre les hôtes membres du cluster de load-balancing. Ces membres du cluster peuvent être identifiés comme des "back-end".    

- un [reverse proxy](https://www.it-connect.fr/reverse-proxy-nginx-load-balancing-et-fail-over/) est un serveur qui va servir d'intermédiaire entre les utilisateurs et les serveurs web. Dans notre cas, le reverse proxy aura pour rôle de jouer les load-balancer entre nos serveurs web mais un reverse proxy peut également avoir d'autres fonctions comme des fonctions de sécurité ou des fonctions de mise en cache. De plus, un reverse proxy va également avoir pour mission de rendre invisible toute la partie back end, les utilisateurs s'adresseront à un seul et unique serveur qui gérera ensuite vers quel back-end envoyer la requête.    

**NB:** Un **proxy inverse** peut résoudre les problèmes d'utilisation des ports par les conteneurs et améliorer la disponibilité en facilitant les déploiements sans temps d'arrêt.    

Pour le nginx en resolproxy nous allons partir de l'[image suivante](https://github.com/nginx-proxy/nginx-proxy).    

L'explication du fonctionnement est disponible [ici](http://jasonwilder.com/blog/2014/03/25/automated-nginx-reverse-proxy-for-docker/).    

J'ouvre une fenêtre dans mon navigateur pour lancer une connection à http://localhost:8080/    
![](https://codimd.math.cnrs.fr/uploads/upload_922df67ea17e1d874efa2dee23748327.png)

Lancement de nginx en resolvproxy:    
```
sudo docker run --name NGINX_reverse-proxy -d -p 8080:80 -v /var/run/docker.sock:/tmp/docker.sock -t jwilder/nginx-proxy 
```  
```docker run```: démarrage d'un conteneur docker  
```--name NGINX_reverse-proxy```: j'impse un nom spécifique, parlant, à mon conteneur  
```-d```: en arrière plan  
```-p 8080:80```: --publish, je décide de lier le port 8080 de l'hôte au port 80 du conteneur.  
```-v var/run/docker.sock:/tmp/docker.sock```: montage lié entre var/run/docker.sock (qui est le fichier de socket Unix que le daemon Docker écoute par défaut) et /tmp/docker.sock (fichier de connexions locales)  
```-t```:  
```jwilder/nginx-proxy```: image docker utilisée.   
  
![](https://codimd.math.cnrs.fr/uploads/upload_fe5181f5a49b13d3a812dacb7e550bf0.png)
  
Vérification sur mon navigateur à http://localhost:8080/ que j'ai bien mon jwilder/nginx-proxy qui est accessible sur le port 8080 de ma machine hôte : OK.    
![](https://codimd.math.cnrs.fr/uploads/upload_dee22d0aef998be333dae8ab5afae043.png)
  


Installation puis lancement de terminator pour visualiser les effets du load-balancing:  
```
sudo apt-get install terminator
```  
```
sudo terminator
```  
Modification du fichier ```/etc/hosts``` pour faire correspondre ```m``` vers ```127.0.0.1``` qui est l'adresse de ```localhost```. (ce serait à faire sur mon gestionnaire de nom de domaine en temps normal).  
```
sudo nano /etc/hosts
```  
![](https://codimd.math.cnrs.fr/uploads/upload_f6316ac16969b19bbd0dff56f45e97d5.png)

Je vérifie sur mon navigateur que l'adresse http://m:8080/ fonctionne. OK.  

![](https://codimd.math.cnrs.fr/uploads/upload_449520964a2eabe5d6af2ee00c035c65.png)




Création de 4 fenètres dans le **navigateur terminator** (**Ctrl+Shift+e** et/ou **Ctrl+Shift+o**). Dans ces terminaux, lancement de la commande suivante pour tester le resolve proxy.  
```
docker run -e VIRTUAL_HOST=m --name NGINX_webserver1 -t -i  nginx
```  
```docker run``` : je lance un conteneur docker  
```-e``` : définit les variables d'environnement ;  
```VIRTUAL_HOST=m``` : XXXXXXXXXXXXXXXXXXX  
```--name NGINX_webserver1``` : j'impose un nom *NGINX_webserver1* à mon container plutôt qu'il soit définit arbitrairement ;  
```-i``` : signifie qu'il sera en mode interactif (je peux y entrer des commandes) ;  
```-t``` : me donne un terminal (afin que je puisse l'utiliser, comme si j'utilise ssh, pour entrer dans le conteneur) ;  
```nginx```: nom de l'image docker.  

Je me place en ```root``` sur les 4 terminaux et je lance 4 conteneurs différents nommés NGINX_webserver1, NGINX_webserver2, NGINX_webserver3, NGINX_webserver4.  

![](https://codimd.math.cnrs.fr/uploads/upload_43a605829b0b4172e05c53119f2f3db6.png)

![](https://codimd.math.cnrs.fr/uploads/upload_ab1e6a66a4da615d6d505c218a27fb2e.png)

Sur un terminal, je vérifie que mes 4 conteneurs NGINX sont bien lancés (on notera que par défaut, ils écoutent sur le port 80):  
![](https://codimd.math.cnrs.fr/uploads/upload_5e5394bd56fc95307eef4607f4d048a1.png)

Je teste à nouveau mon adresse http://m:8080/ et j'arrive sur un des serveurs NGINX:  

![](https://codimd.math.cnrs.fr/uploads/upload_2e0bc59d8b28812075d99e150ca0d5ec.png)

En regardant mon terminator, je constate que ce test sur http://m:8080/ m'a envoyé vers le NGINX_webserver4:  

![](https://codimd.math.cnrs.fr/uploads/upload_71209f79c073bf4ed62d72168ae27191.png)

En rafraichissant plusieur fois de suite la page http://m:8080/, j'envoie plusieurs requêtes sur le port 8080. Sur mon terminator, je visualise que mes 4 NGINX_webserver ont été impactés, et que le JWILDER/NGINX-PROXY a joué son rôle de load-balancer en répartissant la charge sur mes 4 NGINX:  

![](https://codimd.math.cnrs.fr/uploads/upload_07deb3864cd0b18fd814859041445623.png)




J'effectue également le test du resolv proxy en lançant, plusieurs fois, la commande suivante dans un terminal à part:  
```
curl m:8080
```  
![](https://codimd.math.cnrs.fr/uploads/upload_780945412205a44fb0ecda4d05d8e489.png)

Je m'aperçois que mes 4 NGINX sont servis tour-à-tour :   
![](https://codimd.math.cnrs.fr/uploads/upload_46b15aec587c6accd0335631a28d467e.png)

Par curiosité, je recherche les 5 adresses IP de mes 5 conteneurs à l'aide de la commande:  
  
```docker inspect [nom_conteneur] | grep IPAddress ```:   
![](https://codimd.math.cnrs.fr/uploads/upload_d61e708a515b22e1e8392062fb5b7a0f.png)  

![](https://codimd.math.cnrs.fr/uploads/upload_eeefae901b59d222c6fbdd3dc02fafc0.png)  

J'effectue un ```docker ps``` dans mon Terminator pour obtenir l'ID de mon conteneur nginx.  
![](https://codimd.math.cnrs.fr/uploads/upload_91d1d634f64737804aedd2737bd0f077.png)  

ID conteneur nginx: **ef0c100bc71d**.  

Je regarde le fichier de configuration nginx qui sera généré à l'adresse suivante``` /etc/nginx/conf.d/default.conf.``` . Grace à la commande suivante, j'exécute le conteneur actif nginx:  
```
docker exec -it ef0c100bc71d bash
```  
pour y rentrer des commandes :  
```
cd /etc/nginx/conf.d/
```  
```
cat default.conf.
```    
![](https://codimd.math.cnrs.fr/uploads/upload_c6df940d75b3df83e76d33819c507395.png)  
![](https://codimd.math.cnrs.fr/uploads/upload_3ad57307310e28474eacc028014ea3cf.png)  

J'effectue un nettoyage de mes conteneurs:  

```docker ps```  
```docker rm -f num_conteneur1 num_conteneur2 num_conteneur3```  

## Etape 2.2: Utilisation de docker compose  

Utilisez docker compose pour déployer vos 4 services nginx et votre loadbalancer.  

J'écris le docker-compose.yml suivant:  
```yaml
# L'argument version permet de spécifier à Docker Compose quelle version on souhaite utiliser  (dans mon cas, j'ai effectuer un >docker compose version pour trouver ma version qui est v2.15.1
version: '2.15.1'
# Je définis la liste des services (ou conteneurs) que je veux faire tourner dans le cadre de mon application.
services:
  # Conteneur 1 - Reverse proxy 
  reverse-proxy:
    image: jwilder/nginx-proxy
    container_name: NGINX_reverse-proxy
    restart: always
    ports:
      - target: 80
        published: 8080 
        protocol: tcp
        mode: ingress
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock

  #Conteneur 2 - NGINX_webserver1
  NGINX_webserver1:
    image: nginx
    container_name: NGINX_webserver1
    environment:
      VIRTUAL_HOST: m

  #Conteneur 3 - NGINX_webserver2
  NGINX_webserver2:
    image: nginx
    container_name: NGINX_webserver2
    environment:
      VIRTUAL_HOST: m

  #Conteneur 4 - NGINX_webserver3
  NGINX_webserver3:
    image: nginx
    container_name: NGINX_webserver3
    environment:
      VIRTUAL_HOST: m

  #Conteneur 5 - NGINX_webserver4
  NGINX_webserver4:
    image: nginx
    container_name: NGINX_webserver4
    environment:
      VIRTUAL_HOST: m
```  



Je lance mon docker-compose avec la commande:  
```sudo docker ps -a```: pour vérifier que je n'ai pas de conteneurs lancés;  
```sudo docker compose up -d``` pour lancer mon docker-compose;  
```sudo docker ps -a``` pour visualiser mes 5 conteneurs.  
  
![](https://codimd.math.cnrs.fr/uploads/upload_eb2cdb66759903fd1069cb80984e3bfd.png)  
  
Je lance mon navigateur sur http://m:8080/  
![](https://codimd.math.cnrs.fr/uploads/upload_c9e8a2c4080fea41cac0635a56526692.png)  
  
Je regarde les adresses IP de mes nouveaux conteneurs (grâce aux noms donnés aux conteneurs, je peux réutiliser les commandes effectuées précédemment):    
![](https://codimd.math.cnrs.fr/uploads/upload_696ab1d702dd6846512ef6f75964d754.png)    
  
  
## Etape 3: Dockeriser une application existante     
  
https://github.com/barais/TPDockerSampleApp/    
  
  Nous souhaitons partir d'une application Web de détection de visage. L'application se trouve à https://github.com/barais/TPDockerSampleApp    
         
  Construisez un fichier dockerfile permettant de créer une image docker permettant de lancer cette application.    
      
Je choisis d'utiliser Ubuntu 16.04, car c'est la dernière version d'Ubuntu avec libjasper1 disponible.
           
Je teste les commandes suivantes dans un conteneur Ubuntu dans un premier temps:     
```docker run -it -p 8080:8080 ubuntu:16.04 /bin/bash```          
```apt-get update &&  apt-get install -y git```          
```apt-get install -y openjdk-8-jdk maven git```  
```apt-get install -f -y libpng16-16 libjasper1 libdc1394-22```  
```git clone https://github.com/barais/TPDockerSampleApp.git```  
```cd ./TPDockerSampleApp/```
```mvn install:install-file -Dfile=./lib/opencv-3410.jar -DgroupId=org.opencv  -DartifactId=opencv -Dversion=3.4.10 -Dpackaging=jar```  
```mvn package```  
```java -Djava.library.path=lib/ -jar target/fatjar-0.0.1-SNAPSHOT.jar```  
   
Après cette commande, j'effectue un test sur http://localhost:8080/   
    
J'arrive à faire tourner l'application.  
Preuve:   
![](https://codimd.math.cnrs.fr/uploads/upload_e738399e00f26042fe73724b03fc622d.png)  

J'écris donc le dockerfile correspondant aux lignes de commandes ci-dessus:  
```dockerfile=
FROM ubuntu:16.04
EXPOSE 8080
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk maven git libpng16-16 libjasper1 libdc1394-22 && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/barais/TPDockerSampleApp.git
WORKDIR /TPDockerSampleApp
RUN mvn install:install-file -Dfile=./lib/opencv-3410.jar \
     -DgroupId=org.opencv  -DartifactId=opencv -Dversion=3.4.10 -Dpackaging=jar
RUN mvn package
CMD java -Djava.library.path=lib/ -jar target/fatjar-0.0.1-SNAPSHOT.jar
```   
   
Puis, avec la commande ```build```, je construis l'image à partir de mon dockerfile (pas de majuscules dans le nom de l'image!).    
```sudo docker build -t image_tpdocker_sample_app_boutin .```  
   
   J'obtiens à la fin, dans mon terminal:
![](https://codimd.math.cnrs.fr/uploads/upload_cddb591850a635ccbf4209890dad79f8.png)   
   
Je rentre alors la commande:
```sudo docker images``` et j'obtiens:   
![](https://codimd.math.cnrs.fr/uploads/upload_758ec9d8f18bbd37980f77f3e22bbce7.png)

Je lance la commande:   
```sudo docker run -p 8080:8080 image_tpdocker_sample_app_boutin``` et j'obtiens sur mon termial:  
  ![](https://codimd.math.cnrs.fr/uploads/upload_bedfe7a07626b6458970f57583a81c7e.png)  
  
Je me rends à l'adresse http://localhost:8080/ et j'obtiens:  
    
![](https://codimd.math.cnrs.fr/uploads/upload_fd3fad193b7f358c080656c9b82cd0ff.png)  
  
Sur mon terminal s'affiche alors:  
  ![](https://codimd.math.cnrs.fr/uploads/upload_2e80f1e505cdbf453011b10711ae6931.png)  
  
Mon image fait 864MB, et plus précisemment 864054068 octets (pour le concours du paquet de carambars):
![](https://codimd.math.cnrs.fr/uploads/upload_51af31e6de3f60e33f2b902379266767.png)   
  
  Maintenant que j'ai une image fonctionnelle, je vais essayer d'en réduire la taille en modifiant le dockerfile : 
  - je vais tester avec d'autres images de base que ```ubuntu:16.04``` ;
  - je vais réduire le nombre de lignes de mon dockerfile en mutualisant certaines commandes ;
  - je vais essayer de supprimer les paquets temporaires après l'installation des paquets.
  
```dockerfile=
FROM ubuntu:16.04
EXPOSE 8080
RUN apt-get update && \
    apt-get install -y git openjdk-8-jdk maven libpng16-16 libjasper1 libdc1394-22 && \
    git clone https://github.com/barais/TPDockerSampleApp.git && \
    cd TPDockerSampleApp && \
    mvn install:install-file -Dfile=./lib/opencv-3410.jar \
        -DgroupId=org.opencv -DartifactId=opencv -Dversion=3.4.10 -Dpackaging=jar && \
    mvn package && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf TPDockerSampleApp && \
    find /var/log -type f -delete
CMD java -Djava.library.path=lib/ -jar target/fatjar-0.0.1-SNAPSHOT.jar
```  
Avec ce docker file, j'obtiens une image de taille 833124652 octets (gain de 30929416 octets).  
Commande ```sudo docker inspect [image_ID] --format='{{.Size}}'```  
  
![](https://codimd.math.cnrs.fr/uploads/upload_5513fdd7dfd348b68386287cdb67252c.png)  
  
  Comme je ne trouve pas la taille de l'image satisfaisante, j'utilise l'outil [**DIVE**](https://github.com/wagoodman/dive) pour trouver des pistes d'amélioration et d'optimisation:
  ```sudo dive build -t image_tpdocker_sample_app_boutin .```
  
  DIVE m'annonce une image à 833 MB, avec un gain possible de 51 MB (94% d'efficacité).
  
  ![](https://codimd.math.cnrs.fr/uploads/upload_2c2cc6c915e26927400cdadd48f09575.png)

J'analyse les WARNING lors de la construction de mon image à partir du dockerfile.
```
[WARNING] Some problems were encountered while building the effective model for fr.ensai:projetESIR:jar:0.0.1-SNAPSHOT
[WARNING] 'dependencies.dependency.(groupId:artifactId:type:classifier)' must be unique: org.glassfish.jersey.media:jersey-media-multipart:jar -> duplicate declaration of version 2.28 @ line 37, column 15
[WARNING] 
[WARNING] It is highly recommended to fix these problems because they threaten the stability of your build.
[WARNING] 
[WARNING] For this reason, future Maven versions might no longer support building such malformed projects.
```
et
```
[WARNING] 
[WARNING] Some problems were encountered while building the effective model for fr.ensai:projetESIR:jar:0.0.1-SNAPSHOT
[WARNING] 'dependencies.dependency.(groupId:artifactId:type:classifier)' must be unique: org.glassfish.jersey.media:jersey-media-multipart:jar -> duplicate declaration of version 2.28 @ line 37, column 15
[WARNING] 
[WARNING] It is highly recommended to fix these problems because they threaten the stability of your build.
[WARNING] 
[WARNING] For this reason, future Maven versions might no longer support building such malformed projects.
[WARNING] 
```
et
```
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] jakarta.json-1.1.5.jar, javax.json-1.1.4.jar define 94 overlapping classes: 
[WARNING]   - javax.json.JsonString
[WARNING]   - javax.json.JsonValue
[WARNING]   - javax.json.stream.JsonLocation
[WARNING]   - javax.json.Json
[WARNING]   - org.glassfish.json.JsonParserImpl$4
[WARNING]   - org.glassfish.json.JsonMessages
[WARNING]   - javax.json.stream.JsonParser$Event
[WARNING]   - org.glassfish.json.JsonGeneratorImpl
[WARNING]   - org.glassfish.json.JsonBuilderFactoryImpl
[WARNING]   - org.glassfish.json.NodeReference$ArrayReference
[WARNING]   - 84 more...
[WARNING] maven-shade-plugin has detected that some class files are
[WARNING] present in two or more JARs. When this happens, only one
[WARNING] single version of the class is copied to the uber jar.
[WARNING] Usually this is not harmful and you can skip these warnings,
[WARNING] otherwise try to manually exclude artifacts based on
[WARNING] mvn dependency:tree -Ddetail=true and the above output.
[WARNING] See http://maven.apache.org/plugins/maven-shade-plugin/
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] Discovered module-info.class. Shading will break its strong encapsulation.
[WARNING] jakarta.json-1.1.5.jar, javax.json-1.1.4.jar define 94 overlapping classes: 
[WARNING]   - javax.json.JsonString
[WARNING]   - javax.json.JsonValue
[WARNING]   - javax.json.stream.JsonLocation
[WARNING]   - javax.json.Json
[WARNING]   - org.glassfish.json.JsonParserImpl$4
[WARNING]   - org.glassfish.json.JsonMessages
[WARNING]   - javax.json.stream.JsonParser$Event
[WARNING]   - org.glassfish.json.JsonGeneratorImpl
[WARNING]   - org.glassfish.json.JsonBuilderFactoryImpl
[WARNING]   - org.glassfish.json.NodeReference$ArrayReference
[WARNING]   - 84 more...
[WARNING] maven-shade-plugin has detected that some class files are
[WARNING] present in two or more JARs. When this happens, only one
[WARNING] single version of the class is copied to the uber jar.
[WARNING] Usually this is not harmful and you can skip these warnings,
[WARNING] otherwise try to manually exclude artifacts based on
[WARNING] mvn dependency:tree -Ddetail=true and the above output.
[WARNING] See http://maven.apache.org/plugins/maven-shade-plugin/
```     
   
Je décide d'aller modifier les fichiers utilisés. Je fork le projet sur mon GitHub pour traiter les WARNING du build.   
   
1- Pour traiter mes deux premiers WARNING, je modifie mon fichier pom.xml, car il y a le doublon suivant (lignes 37 à 41 identiques aux lignes 31 à 35):  
 ```xml
<dependency>
		<groupId>org.glassfish.jersey.media</groupId>
		<artifactId>jersey-media-multipart</artifactId>
		<version>2.28</version>
</dependency>
```       
   
2- Pour traiter le dernier WARNING ... **je n'y arrive pas depuis deux semaines (j'arrête le TP le 16/02/2023).**    
  
   
Au final, j'obtiens une application qui fonctionne avec le dockerfile suivant:  
```dockerfile
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
```  
  
La taille de l'image est maintenant de 833124567 octets.   


Compte-rendu de TP en ligne sur GitHUB  
Signé: Walfroy BOUTIN
