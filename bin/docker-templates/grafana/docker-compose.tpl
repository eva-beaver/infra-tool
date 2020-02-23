  grafana:
    image: grafana/docker
    container_name: grafana
    build:
      context: %s/docker-templates/grafana
    volumes:
      - scptdirreplace/docker-templates/grafana/provisioning:/etc/grafana/provisioning
    ports:
     - "3000:3000"
    depends_on:
      - prometheus
    networks:
      - local-net
