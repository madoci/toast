# Table des matières
[Git flow](#git-flow)  
[Semantic-versioning](#semantic-versioning)  
[Maven](#maven)  
[Travis CI](#travis-ci)  
[](#)  

# Git flow

### Branches
- **master** : branche principale, contient la dernière release
- **develop** : branche de développement
- **feature/\<feature-name>** : branche de feature basée sur develop
- **bugfix/\<bugfix-name>** : correction de la branche develop
- **release/\<version-tag>** : branche de release basée sur develop (ex: release/1.2.0)
- **hotfix/\<version-tag>** : correction sur master (ex: hotfix/1.2.2)

### Utilisation

![Git flow chart](./git-flow-chart.png)

##### Feature
Lorsque l'on veut ajouter une nouvelle fonctionnalité au logiciel, on crée une nouvelle branche de feature avec la commande :  
```
git flow feature start <feature-name>
```

Si plusieurs collaborateurs travaillent sur la même feature, cette branche peut être publiée avec la commande :  
```
git flow feature publish [<feature-name>]
```

Lorsque la fonctionnalité a été implémentée et testée, la branche peut être fermée avec la commande :  
```
git flow feature finish [<feature-name>]
```

La feature est alors fuisonnée sur develop et la branche est supprimée.

##### Release
Dès que la branche develop est jugée suffisamment avancée, une nouvelle branche de release est créée depuis develop avec les commandes (il est conseillé de toujours publier la release après sa création) :  
```
git flow release start <version-tag>
git flow release publish [<version-tag>]
```

Les seules modifications apportées à cette branche sont les éventuels bugfix.  
Une fois la release prête pour la production, la branche peut être fermée. Elle est alors fusionnée avec master et develop. Le tag de version doit ensuite être attaché à la release sur master avec la commande :  
```
git push origin --tags
```


##### Hotfix
Si une correction doit être apportée à une release déjà sur master, un hotfix doit être créé avec la commande :  
```
git flow hotfix start <new-version-tag>
```

Le nouveau tag de version est généralement obtenu en incrémentant le numéro du PATCH (voir la section [Numéro de version](#numero-de-version)).  
Lorsque le bug est corrigé, il faut fermé le hotfix avec la commande :  
```
git flow hotfix finish [<new-version-tag>]
```

La branche est alors fusionnée avec master en mettant à jour le tag et avec develop.


# Semantic Versioning
Les numéros de version suivent le principe de Semantic Versioning 2.0.0 (https://semver.org/).
Un numéro de version s'écrit MAJOR.MINOR.PATCH (ex: 1.3.16).
- **MAJOR** : incrémenté lorsque de gros changements ont été effectués (souvent lorsqu'il n'y a pas de rétrocompatibilité avec la version précédente)
- **MINOR** : incrémenté lorsque de nouvelles fonctionnalités ont été ajoutées avec rétrocompatibilité, ou que des corrections majeures ont été apportées
- **PATCH** : incrémenté lorsqu'une ou plusieurs corrections ont été apportées

La première version stable du logiciel est numérotée 1.0.0. Les versions 0.x.y sont réservés aux premières versions de développement.
La release d'un version X.Y.Z est taggée avec le préfixe *v* suivi du numéro de version, c'est-à-dire vX.Y.Z.

# Maven
Maven est un outil utilisé pour gérer et automatiser la production de projets logiciels. Il permet notamment de créer un projet selon une structure de base, et d'automatiser la compilation et l'installation du logiciel.

### Création d'un projet
Pour générer un projet suivant la structure standard de Maven, il faut lancer la commande :
```
mvn archetype:generate -DgroupId=domain.mygroup -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart
```  
- **groupId** : identifiant du groupe développant le logiciel. Il s'agit souvent du nom de domaine inversé (ex: org.blender).
- **artifactId** : nom du projet.

La structure du projet est alors :  
```
my-app/
├── pom.xml
└── src
    ├── main
    │   └── java
    │       └── domain
    │           └── mygroup
    │               └── App.java
    └── test
        └── java
            └── domain
                └── mygroup
                    └── AppTest.java

```
Le fichier pom.xml est le fichier de configuration de Maven pour le projet.

### Numéro de version
Le numéro de version actuel est indiqué dans le fichier pom.xml.  
Il est suffixé de "-SNAPSHOT" lorsqu'il s'agit d'une version en développement. Le code source peut alors être modifié tout en restant sur la même version.  
Lors d'une release, le suffixe "-SNAPSHOT" est retiré et la version est définitive. Tout changement dans le code d'une version de release implique un changement de numéro de version (on incrémente généralement le PATCH).

### Phases et cycle de vie
Maven fonctionne avec un cycle de vie de production décomposé en plusieurs phases. Le cycle par défaut est composé des phases suivantes :
- **validate** : valide si le projet et correct et que toutes les informations nécessaires sont présentes
- **compile** : compile le code source
- **test** : lance les tests unitaires
- **package** : crée le package à partir de code source compilé (en .jar par exemple)
- **verify** : éxamine les résultats des tests d'intégration
- **install** : installe le package dans le dossier local (par défaut, dans $HOME/.m2/repository/my-group/my-app/version/)
- **deploy** : déploie le package final sur le dépôt de package distant

Ces phases sont exécutées séquentiellement. Lancer la commande `mvn package` va donc dans l'ordre exécuter les phases *validate*, *compile*, *test* puis *package*.

# Travis CI
Travis CI est un service en ligne d'intégration continue pour les projets hébergés sur Github. Il permet de définir des tâches à effectuer lorsqu'un commit est envoyé sur le dépôt github.  

### Mise en place
Pour mettre en place Travis CI sur un projet existant, il faut d'abord s'identifier sur [travis-ci.com](https://travis-ci.com) avec son compte github et ajouter le dépôt du projet aux autorisations de Travis CI.  
Ensuite, il faut créer un fichier *.travis.yml* à ajouter à la racine du projet, puis y indiquer le langage de programmation et éventuellement la version de ce langage :
```
language: java
jdk: openjdk8
```

### Travis CI et Maven
A chaque push sur le dépôt distant, Travis CI lance un nouvel environnement, commence par installer les dépendances de Maven, puis exécute le *script* et surveille l'état du build (*passed* ou *failed*).  
Par défaut, le script est `mvn test -B` (compile le code source et lance les tests unitaires).

# Junit

# JaCoCo

# Javadoc

# Docker & Docker Hub

# Autres outils

### CodeCov
CodeCov est un service en ligne permettant d'analyser les rapports de couverture de code (générés par des outils comme JaCoCo) d'un projet logiciel.

### Code Climate
