from module.remote.thriftbackend.ThriftClient import ThriftClient, WrongLogin
import sys

try:
    client = ThriftClient(host="127.0.0.1", port=7227, user="api", password="corenftpx1")
except:
    print "Login was wrong"
    exit()

#define packageID as argument
pid=int(sys.argv[1])

#print packageName    
def PackagePassword(n):
    data = client.getPackageData(n)
    print data.password
PackagePassword(pid)
