
  prometheus:
    image: prometheus/docker
    container_name: prometheus
    build:
      context: prometheus
    volumes:
     - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
    command: "--config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus"
    ports:
     - 9090:9090
    depends_on:
     - micrometerprometheus
    networks:
      - local-net

