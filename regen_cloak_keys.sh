#!/bin/bash

# generate new cloak keys config file

set -e
ck_conf="/opt/unreal/conf/cloak_keys.conf"

echo -e "set {\n\tcloak-keys {" > "$ck_conf"
/opt/unreal/unrealircd gencloak 2>&1 | tail -n3 | xargs -I{} echo -e "\t\t"'"{}";' >> "$ck_conf"
echo -e "\t};\n};" >> "$ck_conf"
chmod go-rwx "$ck_conf"
