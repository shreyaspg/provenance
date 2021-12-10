#/usr/bin bash
function bin() {
    cmd="docker run --rm -ti --name provenance-query provenanceio/provenance:v0.2.0 provenanced $1"
    echo -e $cmd
    ${cmd}
}
function bin_with_keyring() {
    cmd="docker run --rm -ti -v ${PWD}/testnet/keyring-test:/home/provenance/keyring-test --name provenance-query provenanceio/provenance:v0.2.0 provenanced $1"
    echo -e $cmd
    ${cmd}
}
echo -e "Enter key name"
read key
bin_with_keyring "--testnet keys show $key"