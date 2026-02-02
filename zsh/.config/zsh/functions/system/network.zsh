# Ping-based availability
function my-networking-server-notify-alive() {
	if [[ -z "$1" ]]; then
		echo "Usage: my-networking-server-notify-alive <host> [interval=5]"
		return 1
	fi

	local host="$1"
	local interval="${2:-5}"

	command -v notify-send >/dev/null || {
		>&2 echo "ERROR: notify-send not found"
		return 1
	}

	echo "Waiting for $host to respond to ping..."

	while ! ping -c 1 -W 1 "$host" &>/dev/null; do
		sleep "$interval"
	done

	notify-send -a "Network Monitor" "Host is alive" "$host is now reachable"
}

# SSH (TCP) availability
function my-networking-ssh-server-notify-alive() {
	if [[ -z "$1" ]]; then
		echo "Usage: my-networking-ssh-server-notify-alive <host> [port=22] [interval=5]"
		return 1
	fi

	local host="$1"
	local port="${2:-22}"
	local interval="${3:-5}"

	(( ${+commands[nc]} )) || {
		>&2 echo "ERROR: nc (netcat) not found"
		return 1
	}

	command -v notify-send >/dev/null || {
		>&2 echo "ERROR: notify-send not found"
		return 1
	}

	echo "Waiting for SSH on $host:$port..."

	while ! nc -z -w 1 "$host" "$port" &>/dev/null; do
		sleep "$interval"
	done

	notify-send -a "Network Monitor" "SSH server is alive" "$host:$port is now reachable"
}