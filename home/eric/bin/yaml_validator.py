import sys
import pprint
import yaml
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("syntax: %s file.yaml")
    else:
        with open(sys.argv[1], 'r') as fh:
            print(pprint.pformat(yaml.load(fh.read())))
