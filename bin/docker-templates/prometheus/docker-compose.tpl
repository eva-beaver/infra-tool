  prometheus:
    image: prometheus/docker
    container_name: prometheus
    build:
      context: %s/docker-templates/prometheus
    volumes:
     - scptdirreplace/docker-templates/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
    command: "--config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus"
    ports:
     - 9090:9090
    networks:
      - local-net