
import pylab as pl


def gen():
  names = pl.cm.cmapnames
  for n in names:
    txt=n+'.txt';
    print ' - creating colomap %s\n' % txt,
    f=open(txt,'w')
    cm=getattr(pl.cm,n)
    for i in range(cm.N):
      f.write('%10.8f %10.8f %10.8f\n' % cm(i)[0:-1])
    f.close()

if __name__=='__main__':
  gen()


