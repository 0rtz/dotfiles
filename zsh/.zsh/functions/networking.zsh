function my-networking-server-notify-alive() {
	until ping -w 10 -c 2 $1 > /dev/null 2>&1
	do
	done
	notify-send "$1 is alive"
}
compdef my-networking-server-notify-alive=ping

function my-networking-ssh-server-notify-alive() {
	until ssh $1 'exit' > /dev/null 2>&1
	do
	done
	notify-send "$1 is alive"
}
compdef my-networking-ssh-server-notify-alive=ping

function my-networking-ip ()
{
	if command -v curl > /dev/null; then
		curl -s http://ipecho.net/plain; echo
		return
	fi
	if command -v wget > /dev/null; then
		wget -q -O - http://ipecho.net/plain 2>&1; echo
		return
	fi
	>&2 echo -e "\nERROR. Install curl or wget. Exiting..."
	return 1
}
