  db:
    image: baseImagePrefixpostgres
    restart: always
    environment:
      POSTGRES_PASSWORD: example
#                         userid is postgres
  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080