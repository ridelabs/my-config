import sys
import pprint
import json
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("syntax: %s file.json")
    else:
        with open(sys.argv[1], 'r') as fh:
            print(pprint.pformat(json.loads(fh.read())))
