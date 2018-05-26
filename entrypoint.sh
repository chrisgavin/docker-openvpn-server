#!/usr/bin/env sh
set -eu

# Create tun device.
mkdir -p /dev/net/
mknod /dev/net/tun c 10 200

eth="eth0"
br="br0"

if ! ip link show "$br" > /dev/null 2>&1; then
	# Gather details of the current network configuration.
	ip_address=`ip -f inet -o addr show eth0 | cut -d " " -f 7`
	route=`ip route | head -n 1`
	route_spec=`echo "$route" | cut -d " " -f 1`
	route_dest=`echo "$route" | cut -d " " -f 3`
	if [ "$route_spec" != "default" ]; then
		echo "No default gateway found." >&2
		exit 1
	fi

	# Create the bridge interface.
	ip link add name "$br" type bridge
	ip link set dev "$eth" master "$br"
	ifconfig "$eth" 0.0.0.0 promisc up
	ip addr add "$ip_address" dev "$br"
	ip link set "$br" up

	# Restore the old default route.
	ip route add default via "$route_dest"
fi

"$@"
