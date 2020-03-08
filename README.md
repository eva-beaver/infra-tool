# infra-tool
============

### What is this designed to do?
The idea behind this project is to be able to perform all basic tasks that are required by engineers when building, running and testing projects locally (a local devops system).  This code is just a play prototype to see what is possible, I developeed in Bash to learn Bash better and then allow it to be developed further in another language.  The purose is to automate all the repeitative tasks that can cause errors and frustriations.  It also will allow people who do not fully understand the application to be able to run it easily.

One bad point I did not build this with TDD, so maybe I need to add some tests or I will start breaking things soon. :(

## Features
It provides the following features which are defined in a manifest.

* Build projects
* Run project
* Build docker file
* Run docker image
* Build docker network
* Run docker network
* Tag and Push docker images to a docker repository e.g. dockerhub.io

It also can be used to generate docker-compose files from templaes using what is in the manifest

## Installing

just do a git pull

## Basically What you need to run things

If componets are missing the script will let you know what is mising.

* jq
* Git
* Maven
* Gradle (to install wrapper > gradle wrapper --gradle-version 6.2 --distribution-type all)
* sdkman
* Docker & docker-compose
* Up to date version of bash

Installing jq
```shell
brew update && brew install jq
```

Installing sdkman (https://sdkman.io/install)
```shell
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk version
```

Note: Mac os/x does not seemm to ship with an up to date version of bash, so please update it with 
```shell
brew unlink bash
brew update && brew install bash
```

## What's in here

Top level directory
```
    |
    |_______ bin <- Bash scripts
    |_______ docker-templates <- Template used for generating docker-compose file
            |_______ activemq <- Template used for generating the activemq docker-compose file components
            |_______ elk <- Template used for generating the elk stack docker-compose file components
            |_______ grafana <- Template used for generating the grafana docker-compose file components
                    |_______ dashboards <-  Dashboards export from grafana
                    |_______ provisioning <- Content to load on start
                            |_______ dashboards <- Dashboards to load
                            |_______ datasources <- Datasources to load
            |_______ kafka <- Template used for generating the kafka docker-compose file components
            |_______ postgres <- Template used for generating the postgres docker-compose file components
            |_______ prometheus <- Template used for generating the prometheus docker-compose file components
            |_______ springbootadmin <- Template used for generating the springbootadmin docker-compose file components
            |_______ local <- Template used for generating the docker-compose file for the app the manifest is for
            |_______ myStack <- Template used for generating the user stack for the app
    |_______ sample-app <- A sample Java app for testing
            |_______ src <- Source code for app
            |_______ DockerfileTemplate <- Directory where pre-built dockerfile exists
```
    
### Manifest
The functionality is driven from a manifest file which resides in the same project as the source code, this allows functionly to be added and generated from what is contained in the manifest.  The manifest file is created using yaml format 

| Field                          | Example       | Use                                                     |
| ------------------------------ | ------------- | ------------------------------------------------------- |
| version                        | v1.00         | Allows scripts to be able to process different versions of this manifestfile. |
| type                           | java          | Used to define the type of project                      |
| info.id                        | 1             |                                                         |
| info.name                      | myproject     | Project name                                            |
| info.repository                |               |                                                         |
| info.description               |               |                                                         |
| info.categories                |               |                                                         |
| info.environment               |               |                                                         |
| build.buildType                | Maven         | Build type, currently only supports maven               |
| build.jdk                      |               | JDK Version to use                                      |
| build.command                  |               | Build command instructions (Maven/Gradle)               |
| build.targetJarName            |               |                                                         |
| build.targetDir                | /build        | Where executable jar is built into                      |
| build.useWrapper               | 1             | Use wrapper to build project e.g. ./gradlew             |
| build.removeTarget             | 1             | Remove target directory after build                     |
| run.command                    | java -jar     | Options for running java code                           |
| run.targetJarName              |               | Jar name that is generated by the build                 |
| run.entryPointClass            |               | Page name and class name to start application           |
| run.javaopts                   |               | Java opts to be used during run or in docker coonatiner |
| docker.baseImagePrefix         |               | Added infront of docker image for pull requests         |
| docker.repoName                |               | Repo to used for taging and pushing docker images       |
| docker.buildImageName          |               | Docker image name to build from when doing multistage build |
| docker.baseImageName           |               | Docker image name to build from                         |
| docker.containerName           |               | Name to give the docker image.                          |
| docker.version                 |               | Docker image version                                    |
| docker.instanceName            |               | Docker unique instance and assigned when running        |
| docker.dockerfileTemplate      |               | Directory and file name to use pre-built docker image from |
| docker.mutilStageBuild         | 1 or 0        | Allows multistage build (just testing this)             |
| docker.ports                   |               | Docker ports to expose                                  |
| docker.memory                  |               | Memory to be used for docker conatiner                  |
| docker.swapMemory              |               | Swap memory to be used for docker conatiner (if supported) |
| docker.removeDocker            | 1 or 0        | Remove the file that was used to build the image.       |
| docker.saveDockerRun           | 1 or 0        | Save or deleted the file used to start the docker instance |
| docker.health.cmd              |               | http endpoint to check health                           |
| docker.health.interval         |               | Health check interval                                   |
| docker.health.retries          |               | Health check retries                                    |
| docker.health.timeout          |               | Health check timeout                                    |
| docker.health.startperiod      |               | Health check startperiod                                |
| docker.network                 |               | Network name to use                                     |
| docker.ipMask                  | 172.1.1.0/24  | Network mask for generating ip addresses                |
| docker.ipAddr                  |               | Network static ip address                               |
| docker.startNetwork            | 1 or 0        | Create Network if it does not exist                     |
| docker.springBootProfiles      |               | Springboot profiles to start instance with              |
| docker.environmentOptions      |               | Repeating key/value pairs                               |
| docker.useInDockerCompose      |               | Start this when bring up docker compose file            |
| docker.useProjectDockerFile    |               | Start this when bring up docker compose file            |
| docker.dockerFileFormatVersion |               | This allows 3 options for building the docker file      |
|                                |               | 0 = use dockerfile from dockerfileTemplate              |
|                                |               | 1 = version 1 dockerfile                                |
|                                |               | 2 = version 2 dockerfile                                |
| docker.buildDockerImage        | 1 or 0        | Build a docker image                                    |
| docker.startDockerImage        | 1 or 0        | Start this docker image                                 |
| docker.pushDockerImage         | 1 or 0        | Push this docker image to a docker storage hub          |


| Manifest template field        | Use                                                     |
| ------------------------------ | ------------------------------------------------------- |
| dockernwreplace                | Replace with the docker network name docker.network     |
| dockernipeplace                | Replace with the docker ipaddress docker.ipAddr         |

### Build
This script will build your app and dockerise it and optionally run your docker file based on your manifest
Make sure you are in the project that has your manifest file

```shell
(path to this project)/bin/build.sh
```

#### Options

```
-d <- Run in debug mode
-m custommanifest.json <- provide different manifest name
```

## Docker-compose file geneation

The docker-compose file can be generated with a number of pre-configured stacks (or you can add more by adding to the requires section in the manifest)

Currently supported are 

 * Activemq
 * Kafka
 * Prometheus
 * Grafana
 * Spring Boot Admin
 * ELK
 * postgress
 * local << --- Uses's information from the dockerfile section to all it to be used in the compose stack

 Each of this stacks is built from a template file, the default is called docker-compose.tpl for all stacks.  This can be overriden and changed in the manifest.

### Docker Compose
This script will build and optionally run your docker compose file based on your manifest
Make sure you are in the project that has your manifest file

```shell
(path to this project)/bin/dock.sh
```

#### Options

```
-d <- Run in debug mode
-m custommanifest.json <- provide different manifest name
```

 The content of these template file can have template fields which are replaced when the full docker-compose file is built.  As docker-compose file can have any number of the stacks added to it.


#### Template replacement fields
The template replacement fields are used in the '.tpl' files to allow generic replacements for things like network names and ip address, which are independant of the template file.

| template field                 | Use                                                     |
| ------------------------------ | ------------------------------------------------------- |
| scptdirreplace                 | Replace with the directory the scriptis running         |
| ipreplace                      | Replace with the ip address from the requires section   |
| portsReplace                   | Replace with the ports specified for the docker section |
| envReplace                     | Replace with the environments specified for the docker section, plus the profiles sectopn |
| nwnamereplace1                 | Replace with the network name (1) that is used by docker-compose from the manifest |
| nwnamereplace2                 | Replace with the network name (2) that is used by docker-compose from the manifest |
| baseImagePrefix                | Replace with the what is in the node docker.baseImagePrefix |
| containerName                  | Replace with the what is in the node docker.containerName |
| containerVersion               | Replace with the what is in the node docker.version     |

#### dockerCompose section of manifest

| Field                          | Example       | Use                                                     |
| ------------------------------ | ------------- | ------------------------------------------------------- |
| version                        | 3.7           | Version of docker-compose file.                         |
| templateDirectory              |               | Location of template directory.                         |
| networkName                    |               | Network name to use in docker-compose file.             |
| networkType                    | bridge        | Network type to create in docker-compose file.          |
| ipMask                         | 171.16.0.0/24 | Network ip mask to create in docker-compose file.       |
| memory                         | 4096          | Max memory for the compose stack. (not used)            |
| processors                     | 2             | Max no cpu's for the compose stack. (not used)          |
| startAfterBuild                | 0 or 1        | should docker-compose up -d be run after build.         |
| dockerNetworks                 |               | Array of docker networks to generate. (not used)        |

### Requires section
The requires sections repeats for each part of the docker copose file to be build.  If the template file does not exist the build will fail.

| Field                          | Example       | Use                                                     |
| ------------------------------ | ------------- | ------------------------------------------------------- |
| name                           |               | Name of the section points to directory name.           |
| template                       |               | Template file name to use.                              |
| ipAddr                         |               | Network type to create in docker-compose file.          |
| memory                         | 4096          | Max memory for the compose stack. (not used)            |
| required                       | 0 or 1        | should Requires section be used in the build.           |
| volumes                        |               | Array of docker volunes to generate.                    |

##### Example requires
```
  "requires": [
    { 
      "name": "local",
      "template": "docker-compose.tpl",
      "ipAddr": "171.1.1.4",
      "memory": "512", 
      "required": 1,
      "volumes": [
        {
          "volName": "localdata",
          "volDriver": "local",
          "volCreate": 1
        }
      ]
    }
  ]
```

#### Local requires
The example requires is unique in that it allows extrat options to run you project as part of the compose-script that is generated.
For example if you do not have "environment:" then any environment variables or springboot profiles will not be generated.

##### Example local template
```
  localservice:
    image: containerName:containerVersion
    container_name: mycontainer
    portsReplace:
     - 9010:9010
    networks:
      nwnamereplace1:
        ipv4_address: ipreplace
    envReplace:
```

## Kubernetes (k8s)

This section will describe the extions to use for Kubernetes

```
kubectl create deployment democontainer --image=mycontainer --dry-run -o=yaml > deployment.yaml
echo --- >> deployment.yaml
kubectl create service clusterip demo --tcp=8080:8080 --dry-run -o=yaml >> deployment.yaml
kubectl port-forward svc/demo 8080:8080


kubectl run mypod --image=evabeaver/mycontainer:v1 --port=8989 --generator=run-pod/v1
kubectl run mypod --image=mycontainer:v1 --port=8989 --generator=run-pod/v1

kubectl get deployment
kubectl get svc
kubectl get all
kubectl get pods
 

kubectl port-forward mypod 9111:9010

kubectl delete pod/mypod
```
### Kind

https://kind.sigs.k8s.io/docs/user/quick-start/

```
kind load docker-image mycontainer:v2
kubectl run mypod --image=mycontainer:v2 --port=9111 --generator=run-pod/v1
kubectl get pods
kubectl delete pod/mypod
```
eval $(minikube docker-env)
eval $(minikube docker-env -u)


https://spring.io/guides/gs/spring-boot-kubernetes/

https://knative.dev/v0.9-docs/serving/getting-started-knative-app/git

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration

https://spring.io/guides/gs/spring-boot-kubernetes/

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
