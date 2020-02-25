  sonarqube:
    image: baseImagePrefixsonarqube
    ports:
      - "9000:9000"
    networks:
      - nwnamereplace1
    environment:
      - sonar.jdbc.url=jdbc:postgresql://db:5432/sonar
    volumes:
      - sonarqube_conf:/opt/sonarqube/conf
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions

  db:
    image: baseImagePrefixpostgres
    networks:
      - nwnamereplace1
    environment:
      - POSTGRES_USER=sonar
      - POSTGRES_PASSWORD=sonar
    volumes:
      - postgresql:/var/lib/postgresql
      # This needs explicit mapping due to https://github.com/docker-library/postgres/blob/4e48e3228a30763913ece952c611e5e9b95c8759/Dockerfile.template#L52
      - postgresql_data:/var/lib/postgresql/data

#networks:
#  sonarnet:
#    driver: bridge

#volumes:
#  sonarqube_conf:
#  sonarqube_data:
#  sonarqube_extensions:
#  postgresql:
#  postgresql_data: