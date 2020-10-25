#!/usr/bin/bash

ip="
172.17.0.2
172.17.0.3
"

if [ "$1" == "--list" ] ; then
echo '
{
  "gp1": {
    "hosts": ['
for i in $ip; do
echo "      \"$i\"",
done
echo '    ],
	"vars": {
	  "mavariable": "1"
	}
  },
  "_meta": {
	"hostvars": {
	 	"172.17.0.2": {
		"var1": "xavki1"
	  },
	  "172.17.0.3": {
		"var1": "xavki2"
	  }
	}
  }
} 
'
elif [ "$1" == "--host" ]; then
  echo '{"_meta": {"hostvars": {}}}'
else
  echo "{ }"
fi

