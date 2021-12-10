#/usr/bin bash

path=${PWD}/testnet
container_name="provenance_init"


echo "###################################################################################################################"
echo "                                     Running Cosmovisor"
echo "###################################################################################################################"
moniker_name="$(grep moniker ${path}/config/config.toml | cut -d "=" -f 2)"
echo -e "Found moniker${moniker_name}"


docker pull shrys197/fx-private:testnetp >2&>1
if [ $? -eq 0 ];then
    echo -e  "[1] Checking if image exists/pulling \xE2\x9C\x94 "
else 
    echo -e  "[1] Image pull failed \xE2\x9D\x8C "
fi


docker run --name $container_name \
        -v /var/run/aesmd:/var/run/aesmd --device /dev/isgx:/dev/isgx --device /dev/gsgx:/dev/gsgx \
        --rm -ti -p 1317:1317 -p 26657:26657 -p 9090:9090 \
        -v ${PWD}/testnet:/home/provenance \
        shrys197/fx-private:testnetp