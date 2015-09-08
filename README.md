# graphite-coreos-cluster
A Graphite cluster running on CoreOS

# Instructions
1. Clone https://github.com/coreos/coreos-vagrant and setup a cluster: 

    ```
    cp config.rb.sample config.rb
    ````
    
2. Start up the cluster:

    ```
    vagrant up
    ```
    
3. Start the 'graphite nodes' first (here we start two)

    ```
    cd carbon_node/systemd
    fleetctl start carbon-cache@{1,2}.service
    ```
    
4. Start up the carbon relay

    ```
    cd carbon_relay/systemd
    fleetctl start carbon-relay.service
    ```

5. Start up the 'master' graphite web

    ```
    cd graphite_web/systemd
    fleetctl start graphite-web.service
    ```
    
6. You should now be able to hit Graphite on port 80 of the host running graphite_web, and grafana at /grafana/index.html#/dashboard/file/default.json

7. Have your metric clients send stats to the carbon-relay host
