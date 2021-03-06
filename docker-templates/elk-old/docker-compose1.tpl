  # Setting Up the ELK Stack With Spring Boot Microservices
  elasticsearch:
      image: docker.elastic.co/elasticsearch/elasticsearch:6.3.2
      ports:
          - '9200:9200'
          - '9300:9300'
  kibana:
      image: docker.elastic.co/kibana/kibana:6.3.2
      ports:
          - '5601:5601'
      depends_on:
          -  elasticsearch
  logstash:
      image: docker.elastic.co/logstash/logstash:6.3.2
      ports:
          - '25826:25826'
      volumes:
          - $PWD/elk-config:/elk-config
      command: logstash -f /elk-config/logstash.config
      depends_on:
          -  elasticsearch