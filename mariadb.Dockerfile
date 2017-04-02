FROM mariadb:10.1.22

ARG DB_FILE_URL

RUN apt-get update \
    && apt-get install -y curl gettext-base telnet unzip vim-tiny

RUN curl -L -o database.zip ${DB_FILE_URL} \
    && unzip database.zip -d /docker-entrypoint-initdb.d \
    && rm -Rf database.zip

COPY ./my.cnf /etc/mysql/my.cnf.dol

RUN cat /etc/mysql/my.cnf.dol >> /etc/mysql/my.cnf \
    && echo 'alias mysql="mysql -uroot -p${MYSQL_ROOT_PASSWORD}"' >> ~/.bashrc \
    && echo 'alias mysqladmin="mysqladmin -uroot -p${MYSQL_ROOT_PASSWORD}"' >> ~/.bashrc

COPY ./z-create-admin-account.sql /z-create-admin-account.sql
COPY ./mariadb-entrypoint.sh /mariadb-entrypoint.sh

ENTRYPOINT ["/mariadb-entrypoint.sh"]
# CMD [ 'mysqld --innodb-buffer-pool-size=20M' ]
CMD ["mysqld"]
