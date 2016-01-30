#!/usr/bin/env python

import sys
import json
import pprint

x=sys.stdin.read()
x = x.replace("'", '"')
j=json.loads(x)
print pprint.pformat(j)

