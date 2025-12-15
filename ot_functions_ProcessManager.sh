!#/bin/bash


topProcess_memory() {
echo "enter a number: which represents the number of process needed"
read n

    if [[ -z "$n" ]]; then
        echo "You must enter a number."
        return
    fi
    
    ps aux | sort -k4 -nr | head -n $n
}

topProcess_cpu() {
echo "enter a number: which represents the number of process needed"
read n

    if [[ -z "$n" ]]; then
        echo "You must enter a number."
        return
    fi

    ps aux | sort -k3 -nr | head -n $n
}


kill_least_priority() {

    # Step-1: highest nice value
    max_nice=$(ps -eo ni --sort=-ni | head -n 2 | tail -n 1)

    # Step-2: get all PIDs with that value
    pids=$(ps -eo pid,ni | awk -v val="$max_nice" '$2==val {print $1}')

    # Step-3: kill all matching PIDs
    for pid in $pids; do
        echo "Killing PID: $pid (NI=$max_nice)"
        kill -9 "$pid"
    done

    echo "Killed all least priority processes."
}



RunningDurationProcess() {
	echo "enter pid"
	read pid

	if ps aux | awk '{print $2}' | grep -q "^$pid$"; then
		echo "PID $pid exists"
		ps -p "$pid" -o pid,comm,etime
	else
		echo "PID $pid does not exist"
	fi
}

listOrphanProcess() {
    echo "Checking for orphan processes..."

    orphans=$(ps -eo pid,ppid,user,cmd | awk '$2 == 1 && $3 != "root" && $4 !~ /(systemd|daemon|dbus|cron|NetworkManager|sshd|snapd|polkitd|kworker|kthreadd)/')

    if [[ -z "$orphans" ]]; then
        echo "No orphan processes found."
    else
        echo "$orphans"
    fi
}


listZombieProcess() {
    zombies=$(ps -eo pid,stat,cmd --no-headers | awk '$2=="Z"')
    if [[ -z "$zombies" ]]; then
        echo "--No Zombie Process exists in system--"
        return
    fi
    echo "PID     STAT     CMD"
    echo "$zombies"
}


killprocess() {
	if [ -z "$1" ]; then
		echo "Use: $0 <pid or name>"
		exit 1
	fi

	killall "$1" 2>/dev/null || kill "$1" 2>/dev/null || echo "Process not found"
}


listDState() {
    # List all D-state processes
    D_PROCS=$(ps -eo pid,ppid,user,stat,cmd | awk '$4=="D"')

    if [ -z "$D_PROCS" ]; then
        echo "No processes are currently waiting for resources (D-state)."
    else
        echo "Processes waiting for resources (D-state):"
        echo "$D_PROCS"
    fi
}
