"""Reference vectors only: do not confuse with emulated Z80 execution."""
import math

def mul8(a,b):
    return a*b

def div8(a,b):
    if not b:
        raise ZeroDivisionError()
    return divmod(a,b)

def sqrt16(x):
    return math.isqrt(x)

def lcg16(x):
    return (5*x+1)&0xffff

for a in range(256):
    for b in range(256):
        assert 0<=mul8(a,b)<=65535
        if b:
            q,r=div8(a,b)
            assert q*b+r==a and 0<=r<b
for n in range(65536):
    s=sqrt16(n)
    assert s*s<=n<(s+1)*(s+1)
assert lcg16(0)==1
assert lcg16(0xffff)==0xfffc
print("Reference arithmetic vector checks passed (not machine-code execution).")
