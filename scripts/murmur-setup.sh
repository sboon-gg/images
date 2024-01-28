#!/bin/bash

if [[ -f ".murmursetup" ]]; then
    echo "Skipping Setup - already configured"
else
    cd mumo/tools

    python prbf2setup.py -s prmurmurpassword -i "../../PRMurmur.ice"

    CHANNEL_ID="main0"

    python prbf2man.py -c $CHANNEL_ID -n "$SERVER_NAME" -f $GAMESERVER_IP -b 1 -o "../modules-enabled/prbf2.ini" -s prmurmurpassword -i "../../PRMurmur.ice"

    if [[ -v MURMUR_SU_PASS ]]; then
        ./prmurmurd.x64 -supw $MURMUR_SU_PASS
    fi

    touch .murmursetup
fi
