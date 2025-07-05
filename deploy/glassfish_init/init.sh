#!/bin/sh

echo "start-domain

add-library --type common ./custom/mysql-connector-j-9.3.0.jar

create-jdbc-connection-pool \
--restype javax.sql.DataSource \
--datasourceclassname com.mysql.cj.jdbc.MysqlDataSource \
--property "serverName=$MYSQL_HOST:portNumber=$MYSQL_PORT:databaseName=$MYSQL_DATABASE:user=$MYSQL_USER:password=$MYSQL_PASSWORD:useSSL=false:allowPublicKeyRetrieval=true" \
MainPool

create-jdbc-resource --connectionpoolid MainPool jdbc/ClinicDB

stop-domain" | asadmin --interactive=false multimode
