  myStack:
#    image: mycontainer:v1
    image: containerName:containerVersion
    container_name: mycontainer
    ports:
     - 9010:9010
    networks:
      nwnamereplace1:
        ipv4_address: ipreplace
    environment:
#    script: scptdirreplace/sdfsdfdfs/myfile.inf