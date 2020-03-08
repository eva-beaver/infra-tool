  amqservice:
    image: baseImagePrefixlocalservice/v1
    container_name: amqservice
    ports:
     - 9010:9010
    networks:
      nwnamereplace1:
        ipv4_address: ipreplace

#    script: scptdirreplace/sdfsdfdfs/dsfsdfsfsf.xxx    
#    networks:
#      - local-net   ipreplace