import os
import struct
import sys

def calculate_gzip_file_size(file_name):
    # peek at the last 4 bytes of the gzip file to get the uncompressed-file-size, this obviously won't be accurate after 2^(4*8) (4GB)
    size = os.stat(file_name).st_size
    with open(file_name, 'rb') as fh:
        fh.seek(size - 4)
        return struct.unpack('I', fh.read(4))[0]

if __name__ == "__main__":
    if len(sys.argv) >= 2:
        size = calculate_gzip_file_size(sys.argv[1])
        print("Unzipped size: %s"%size)
    else:
        print("syntax: %s filename.gz"%sys.argv[0])
