#!/usr/bin/env python
import random
pw = ""
for i in range(0, 10):
    pw += chr(random.randint(33, 124))
print pw
    
