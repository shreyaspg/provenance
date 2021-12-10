#/usr/bin bash
# set -x
echo "###################################################################################################################"
echo "                                     FX bootstrapper"
echo "###################################################################################################################"

#Globals
path=${PWD}/testnet
container_name="provenance_init"
moniker=$1
#End Globals

if [ -z "$1" ]; then
    echo "Usage: $0 <moniker_name>"
    exit 1
fi
rm -rf ${PWD}/testnet
mkdir -p ${PWD}/testnet
if [ $? -eq 0 ];then
    echo -e  "[1] Created testnet Directory \xE2\x9C\x94 "
else 
    echo -e  "[1] Cannot create testnet Directory \xE2\x9D\x8C "
fi

docker pull shrys197/fx-private:testnetp > /dev/null 2>&1
if [ $? -eq 0 ];then
    echo -e  "[2] Docker pull of node bootstrap done \xE2\x9C\x94 "
else 
    echo -e  "[2] Docker pull of node bootstrap failed \xE2\x9D\x8C "
fi

cmd="docker run --rm --name provenance_bootstrap -v $(pwd)/testnet:/home/provenance provenanceio/node:pio-testnet-1 true"
${cmd}
if [ $? -eq 0 ];then
    echo -e  "[3] Created config at $path \xE2\x9C\x94 "
else 
    echo -e  "[3] Failed to create config at $path \xE2\x9D\x8C "
fi



sed -i 's/log_levels = "info"/log_levels = "error"/g' ${path}/config/config.toml
if [ $? -eq 0 ];then
    echo -e  "[4] Set log level to 'error' \xE2\x9C\x94 "
else 
    echo -e  "[4] Failed to Set log level to 'error' \xE2\x9D\x8C "
fi

sed -i '/db_backend/c\db_backend = "cleveldb"' ${path}/config/config.toml
if [ $? -eq 0 ];then
    echo -e  "[5] Set database backend to 'cleveldb' \xE2\x9C\x94 "
else 
    echo -e  "[5] Failed to Set database backend to 'cleveldb' \xE2\x9D\x8C "
fi

sed -i "/moniker/c\moniker = \"$1\"" ${path}/config/config.toml

if [ $? -eq 0 ];then
    echo -e  "[6] Set moniker name to $1 \xE2\x9C\x94 "
else 
    echo -e  "[6] Failed to Set moniker name to $1 \xE2\x9D\x8C "
fi
echo "###################################################################################################################"
echo "                                     Running Cosmovisor"
echo "###################################################################################################################"

docker run --name $container_name \
        -v /var/run/aesmd:/var/run/aesmd --device /dev/isgx:/dev/isgx --device /dev/gsgx:/dev/gsgx \
        --rm -ti -p 1317:1317 -p 26657:26657 -p 9090:9090 \
        -v ${PWD}/testnet:/home/provenance \
        shrys197/fx-private:testnetp
    
if [ $? -eq 0 ];then
    echo -e  "[7] Started container $container_name \xE2\x9C\x94 "
else 
    echo -e  "[7] Failed to Start container $container_name \xE2\x9D\x8C "
fi
