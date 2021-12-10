#/usr/bin bash
function bin() {
    cmd="docker run --rm -ti -v /var/run/aesmd:/var/run/aesmd --device /dev/isgx:/dev/isgx --device /dev/gsgx:/dev/gsgx --name provenance-query shrys197/fx-private:testnetd $1"
    echo -e $cmd
    ${cmd}
}
function bin_with_keyring() {
    cmd="docker run --rm -ti -v /var/run/aesmd:/var/run/aesmd --device /dev/isgx:/dev/isgx --device /dev/gsgx:/dev/gsgx -v ${PWD}/testnet/keyring-test:/home/provenance/keyring-test --name provenance-query shrys197/fx-private:testnetd $1"
    echo -e $cmd
    ${cmd}
}
echo -e "Enter key name"
read key
bin_with_keyring "--testnet keys show $key"