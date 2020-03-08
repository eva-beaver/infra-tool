  localservice:
#    image: mycontainer:v1
    image: containerName:containerVersion
    container_name: mycontainer
    portsReplace:
    networks:
      nwnamereplace1:
        ipv4_address: ipreplace
    envReplace:
#    script: scptdirreplace/sdfsdfdfs/myfile.inf