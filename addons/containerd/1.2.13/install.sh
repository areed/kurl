

function containerd_install() {
    local src="$DIR/addons/containerd/1.2.13"

    if [ "$SKIP_CONTAINERD_INSTALL" = "1" ]; then
        return 0
    fi

    containerd_binaries "$src"
    containerd_configure
    containerd_registry
    containerd_service "$src"
}

function containerd_binaries() {
    local src="$1"

    if [ ! -f "$src/assets/containerd.tar.gz" ] && [ "$AIRGAP" != "1" ]; then
        mkdir -p "$src/assets"
        curl -L "https://github.com/containerd/containerd/releases/download/v1.2.13/containerd-1.2.13-linux-amd64.tar.gz" > "$src/assets/containerd.tar.gz"
    fi

    tar xzf "$src/assets/containerd.tar.gz" -C /usr/local
}

function containerd_service() {
    local src="$1"

    local systemdVersion=$(systemctl --version | head -1 | awk '{ print $NF }')
    if [ $systemdVersion -ge 226 ]; then
        cp "$src/containerd.service" /etc/systemd/service/containerd.service
    else
        cat "$src/containerd.service" | sed '/TasksMax/s//# &/' > /etc/systemd/service/container.service
    fi

    systemctl daemon-reload
    systemctl enable containerd.service
    systemctl start containerd.service
}

function containerd_configure() {
    if [ -f "/etc/containerd/config.toml" ]; then
        return 0
    fi

    sleep 1

    mkdir -p /etc/containerd
    containerd config default > /etc/containerd/config.toml

    sed -i 's/systemd_cgroup = false/systemd_cgroup = true/' /etc/containerd/config.toml

    systemctl restart containerd
    systemctl enable containerd
}
