#!/bin/bash

# Source your functions file
source /home/saransh/Ninja_33_Assignments/ot_functions_ProcessManager.sh

while true; do
    echo "================ Process Manager ================"
    echo "1) Top processes by Memory usage"
    echo "2) Top processes by CPU usage"
    echo "3) Kill least priority processes"
    echo "4) Process running duration by PID"
    echo "5) List Orphan processes"
    echo "6) List Zombie processes"
    echo "7) Kill process by PID or Name"
    echo "8) List D-state processes (waiting for resources)"
    echo "9) Exit"
    echo "================================================"
    read -p "Enter your choice [1-9]: " choice

    case $choice in
        1)
            topProcess_memory
            ;;
        2)
            topProcess_cpu
            ;;
        3)
            kill_least_priority
            ;;
        4)
            RunningDurationProcess
            ;;
        5)
            listOrphanProcess
            ;;
        6)
            listZombieProcess
            ;;
        7)
            read -p "Enter PID or Process Name to kill: " target
            killprocess "$target"
            ;;
        8)
            listDState
            ;;
        9)
            echo "Exiting Process Manager..."
            break
            ;;
        *)
            echo "Invalid option! Please choose 1-9."
            ;;
    esac
    echo ""
done
