
function addon() {
    local name=$1
    local version=$2

    if [ -z "$version" ]; then
        return 0
    fi

    logStep "Addon $name $version"

    rm -rf $DIR/kustomize/$name
    mkdir -p $DIR/kustomize/$name

    if [ "$AIRGAP" != "1" ] && [ -n "$KURL_URL" ]; then
        curl -sSLO "$KURL_URL/dist/$name-$version.tar.gz"
        tar xf $name-$version.tar.gz
        rm $name-$version.tar.gz
    fi

    . $DIR/addons/$name/$version/install.sh

    $name
}
