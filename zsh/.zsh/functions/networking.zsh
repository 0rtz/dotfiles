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
