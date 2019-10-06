#!/bin/bash

if [[ ! -e "/opt/unreal/conf/cloak_keys.conf" ]]; then
    /opt/unreal/regen_cloak_keys.sh
fi

/opt/unreal/bin/unrealircd -F
