export PGPASSWORD=transitime
export AGENCYNAME=GOHART
export AGENCYID=1
export GTFS_URL="http://gohart.org/google/google_transit.zip"
export GTFSRTVEHICLEPOSITIONS="http://realtime.prod.obahart.org:8088/vehicle-positions"

docker stop transitime-db
docker stop transitime-server-instance

docker rm transitime-db
docker rm transitime-server-instance

docker build --no-cache -t transitime-server .

docker run --name transitime-db -p 5432:5432 -e POSTGRES_PASSWORD=$PGPASSWORD -d postgres

docker run  --name transitime-server-instance --rm --link transitime-db:postgres -e AGENCYID=$AGENCYID -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME transitime-server ./check_db_up.sh

docker run  --name transitime-server-instance --rm --link transitime-db:postgres -e AGENCYID=$AGENCYID -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME transitime-server ./create_tables.sh

docker run  --name transitime-server-instance --rm --link transitime-db:postgres -e AGENCYID=$AGENCYID -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME -e GTFS_URL=$GTFS_URL transitime-server ./import_gtfs.sh

docker run --name transitime-server-instance --rm --link transitime-db:postgres -e AGENCYID=$AGENCYID -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME transitime-server ./create_api_key.sh

docker run --name transitime-server-instance --rm --link transitime-db:postgres -e AGENCYID=$AGENCYID -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME transitime-server ./create_webagency.sh

docker run --name transitime-server-instance --rm --link transitime-db:postgres -e AGENCYID=$AGENCYID -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME transitime-server ./import_avl.sh

docker run --name transitime-server-instance --rm --link transitime-db:postgres -e AGENCYID=$AGENCYID -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME transitime-server ./process_avl.sh

docker run --name transitime-server-instance --rm --link transitime-db:postgres -e AGENCYID=$AGENCYID -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME -e GTFSRTVEHICLEPOSITIONS=$GTFSRTVEHICLEPOSITIONS -e GTFS_URL=$GTFS_URL -p 8080:8080 transitime-server  ./start_transitime.sh
