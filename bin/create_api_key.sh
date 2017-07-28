#!/usr/bin/env bash
echo 'TRANSIIIME DOCKER: Create API key.'
# This is to substitute into config file the env values
find /usr/local/transitime/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_ADDR"#"$POSTGRES_PORT_5432_TCP_ADDR"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_PORT"#"$POSTGRES_PORT_5432_TCP_PORT"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"PGPASSWORD"#"$PGPASSWORD"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"AGENCYNAME"#"$AGENCYNAME"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"GTFSRTVEHICLEPOSITIONS"#"$GTFSRTVEHICLEPOSITIONS"#g {} \;

java -jar /usr/local/transitime/CreateAPIKey.jar -c "/usr/local/transitime/config/transiTimeConfig.xml" -d "foo" -e "og.crudden@gmail.com" -n "Sean Og Crudden" -p "123456" -u "http://www.transitime.org"