#/usr/bin bash

function bin() {
    cmd="docker run --rm -ti -v /var/run/aesmd:/var/run/aesmd --device /dev/isgx:/dev/isgx --device /dev/gsgx:/dev/gsgx --name provenance-query shrys197/fx-private:testnetd $1"
    echo -e $cmd
    ${cmd}
}
function bin_with_keyring() {
    cmd="docker run --rm -ti -v /var/run/aesmd:/var/run/aesmd --device /dev/isgx:/dev/isgx --device /dev/gsgx:/dev/gsgx -v $(pwd)/testnet:/home/provenance -v ${PWD}/testnet/keyring-test:/home/provenance/keyring-test --name provenance-query shrys197/fx-private:testnetd $1"
    echo -e $cmd
    ${cmd}
}
moniker_name="$(grep moniker ${path}/config/config.toml | cut -d "=" -f 2)"
echo -e "Found moniker${moniker_name}"

echo -e "Enter key name"
read keyname
bin_with_keyring "--testnet keys show $keyname"
echo -e "\n"
echo -e "Enter the key generated"
read key
echo -e "\n"
bin_with_keyring "--testnet tendermint show-validator"
echo -e "\n"
echo -e "Enter the pubkey generated"
read pubkey


echo -e "\n"
bin_with_keyring "--testnet --chain-id pio-testnet-1 tx staking create-validator --moniker $moniker_name --amount 1000nhash --from $key --pubkey $pubkey --fees 5000nhash --commission-rate=1.0 --commission-max-rate=1.0 --commission-max-change-rate=1.0 --min-self-delegation 1 --broadcast-mode block"