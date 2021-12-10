#/usr/bin bash
function bin() {
    cmd="docker run --rm -ti -v /var/run/aesmd:/var/run/aesmd --device /dev/isgx:/dev/isgx --device /dev/gsgx:/dev/gsgx --name provenance-query shrys197/fx-private:testnetd $1"
    echo -e "\n$cmd\n"
    ${cmd}
}
function bin_with_keyring() {
    cmd="docker run --rm -ti -v /var/run/aesmd:/var/run/aesmd --device /dev/isgx:/dev/isgx --device /dev/gsgx:/dev/gsgx -v ${PWD}/testnet/keyring-test:/home/provenance/keyring-test --name provenance-query shrys197/fx-private:testnetd $1"
    echo -e "\n$cmd\n"
    ${cmd}
}

echo -e "Enter the key generated"
read key

bin_with_keyring "--testnet q bank balances $key --node=tcp://rpc-0.test.provenance.io:26657"