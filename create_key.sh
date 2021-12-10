#/usr/bin bash
echo "###################################################################################################################"
echo "                                     Key Generator"
echo "###################################################################################################################"

function bin() {
    cmd="docker run -v /var/run/aesmd:/var/run/aesmd --device /dev/isgx:/dev/isgx --device /dev/gsgx:/dev/gsgx --rm -ti --name provenance-query shrys197/fx-private:testnetd $1"
    echo -e "\n$cmd"
    ${cmd}
}
function bin_with_keyring() {
    cmd="docker run -v /var/run/aesmd:/var/run/aesmd --device /dev/isgx:/dev/isgx --device /dev/gsgx:/dev/gsgx --rm -ti -v ${PWD}/testnet/keyring-test:/home/provenance/keyring-test --name provenance-query shrys197/fx-private:testnetd $1"
    echo -e "\n$cmd"
    ${cmd}
}

docker pull provenanceio/provenance:v0.2.0 > /dev/null 2>&1
if [ $? -eq 0 ];then
    echo -e  "[1] Docker pull of image provenanceio/provenance:v0.2.0 done \xE2\x9C\x94 "
else 
    echo -e  "[1] Docker pull of image provenanceio/provenance:v0.2.0 failed \xE2\x9D\x8C "
fi

if [ $1 == 'y' ];then
    echo "Using default name as secure_key"
    key_name="secure_key"
else
    echo -e "Enter name of key"
    read key_name
fi

# bin_with_keyring "keys add $key_name --coin-type=1 --testnet  -i"

echo -e "Enter the key generated"
read key

cmd="curl https://test.provenance.io/blockchain/faucet/external  \
  -X POST  -H Content-Type: application/json  \
--data-binary {\"address\":\"$key\"}"
${cmd}


bin_with_keyring "--testnet query auth account $key --node=tcp://rpc-0.test.provenance.io:26657"

if [ $? -eq 0 ];then
    echo -e  "[2] Authentication of $key Successful \xE2\x9C\x94 "
else 
    echo -e  "[2] Authentication of $key failed \xE2\x9D\x8C "
fi

bin_with_keyring "--testnet testnet"
if [ $? -eq 0 ];then
    echo -e  "[3] Creating files for validator mode \xE2\x9C\x94 "
else 
    echo -e  "[3] Failed creating files for validator mode \xE2\x9D\x8C "
fi