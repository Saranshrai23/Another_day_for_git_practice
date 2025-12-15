#!/bin/bash

# Require root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as sudo or root"
    exit 1
fi

# Require at least 1 argument

if [ $# -lt 1 ]; then
    echo "Usage: ./UserManager.sh <action> [arguments]"
    echo ""
    echo "Available actions:"
    echo "  addTeam <teamname>"
    echo "  addUser <username> <teamname>"
    echo "  changeShell <username> <shell>"
    echo "  changePasswd <username>"
    echo "  delUser <username>"
    echo "  delTeam <teamname>"
    echo "  lsUser"
    echo "  lsTeam"
    exit 1
fi

action=$1

if [ "$action" = "addTeam" ]; then
    team=$2
    if grep -q "^$team:" /etc/group; then
        echo "Team $team already exists"
    else
        groupadd "$team"
        echo "Team $team created"
    fi

elif [ "$action" = "addUser" ]; then
    user=$2
    team=$3

    if ! grep -q "^$team:" /etc/group; then
        echo "Team $team does not exist"
        exit 1
    fi

    if grep -q "^$user:" /etc/passwd; then
        echo "User $user already exists"
        exit 1
    fi

    # Create user
    useradd -m -g "$team" "$user"

    # Home directory perms
    chmod 751 /home/"$user"

    # Create shared dirs
    mkdir /home/"$user"/team
    mkdir /home/"$user"/ninja

    # Correct GROUP OWNERSHIP
    chown "$user":"$team" /home/"$user"/team
    chmod 770 /home/"$user"/team

    groupadd -f ninja
    chown "$user":ninja /home/"$user"/ninja
    chmod 770 /home/"$user"/ninja

    echo "User $user added to $team"


elif [ "$action" = "changeShell" ]; then
    user=$2
    shell=$3
    if ! grep -q "^$user:" /etc/passwd; then
        echo "User $user does not exist"
        exit 1
    fi
    chsh -s "$shell" "$user"
    echo "Shell for $user changed to $shell"

elif [ "$action" = "changePasswd" ]; then
    user=$2
    if ! grep -q "^$user:" /etc/passwd; then
        echo "User $user does not exist"
        exit 1
    fi
    passwd "$user"

elif [ "$action" = "delUser" ]; then
    user=$2
    if ! grep -q "^$user:" /etc/passwd; then
        echo "User $user does not exist"
        exit 1
    fi
    userdel -r "$user"
    echo "User $user deleted"

elif [ "$action" = "delTeam" ]; then
    team=$2

    # Check if group exists
    if ! grep -q "^$team:" /etc/group; then
        echo "Team $team does not exist"
        exit 1
    fi

    # Get the GID of the group
    gid=$(getent group "$team" | cut -d: -f3)

    # Check for users whose primary GID is this GID (without loops)
    users_in_team=$(grep ":$gid:" /etc/passwd | cut -d: -f1)

    if [ -n "$users_in_team" ]; then
        echo "Cannot delete team '$team' because the following users still have it as primary group:"
        echo "$users_in_team"
        echo "Delete users first with: sudo ./UserManager.sh delUser <username>"
        exit 1
    fi

    # Check for supplementary users (listed in group line)
    supp_members=$(getent group "$team" | cut -d: -f4)
    if [ -n "$supp_members" ]; then
        echo "Cannot delete team '$team' because these users are still members of the group:"
        echo "$supp_members"
        echo "Remove them from group first or delete users."
        exit 1
    fi

    groupdel "$team"
    echo "Team $team deleted successfully"

elif [ "$action" = "lsUser" ]; then
    ls /home

elif [ "$action" = "lsTeam" ]; then
    cut -d: -f1 /etc/group

else
    echo "Invalid action"
fi

