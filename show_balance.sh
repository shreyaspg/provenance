#/usr/bin bash
function bin() {
    cmd="docker run --rm -ti --name provenance-query provenanceio/provenance:v0.2.0 provenanced $1"
    echo -e "\n$cmd\n"
    ${cmd}
}
function bin_with_keyring() {
    cmd="docker run --rm -ti -v ${PWD}/testnet/keyring-test:/home/provenance/keyring-test --name provenance-query provenanceio/provenance:v0.2.0 provenanced $1"
    echo -e "\n$cmd\n"
    ${cmd}
}

echo -e "Enter the key generated"
read key

bin_with_keyring "--testnet q bank balances $key --node=tcp://rpc-0.test.provenance.io:26657"