#version: '3.7'

#services:
  springboot-json-logging:
    build: ../springboot-json-logging
    labels:
      filebeat_enable:
    networks:
      helloworld:
        ipv4_address: 172.1.1.10 ipreplace
    ports:
      - "8080:8080"

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:6.5.4
    networks:
      helloworld:
        ipv4_address: 172.1.1.20
    ports:
      - "9200:9200"
      - "9300:9300"
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 65536
        hard: 65536
    volumes:
      - esdata2:/usr/share/elasticsearch/data
      
#        volumes:
#      - /tmp/data:/usr/share/elasticsearch/data

  kibana:
    image: docker.elastic.co/kibana/kibana:6.5.4
    networks:
      helloworld:
        ipv4_address: 172.1.1.30
    ports:
    - "5601:5601"
    links:
      - elasticsearch

  logstash:
    build: ./logstash
    networks:
      helloworld:
        ipv4_address: 172.1.1.40
    command: logstash -f /conf/logstash-spring-boot.conf
    ports:
      - "5044:5044"
    links:
      - elasticsearch

  filebeat:
    build: ./filebeat
    links:
      - springboot-json-logging
      - logstash
    networks:
      helloworld:
        ipv4_address: 172.1.1.50
    volumes:
    # needed to access all docker logs :
    - "/var/lib/docker/containers:/var/lib/docker/containers"
    # needed to access additional information about containers
    - "/var/run/docker.sock:/var/run/docker.sock"

volumes:ARR_REQUIRE_TEMPLATE
  esdata2:
    driver: local

networks:
  helloworld:
    driver: "bridge"
    ipam:
      config:
        - subnet: 172.1.1.0/24
  
