from module.remote.thriftbackend.ThriftClient import ThriftClient, WrongLogin
import sys

try:
    client = ThriftClient(host="127.0.0.1", port=7227, user="api", password="XXX")
except:
    print "Login was wrong"
    exit()

#define packageID as argument
fid=int(sys.argv[1])

#print packageName    
def PackageID(n):
    data = client.getFileData(n)
    print data.packageID
PackageID(fid)
