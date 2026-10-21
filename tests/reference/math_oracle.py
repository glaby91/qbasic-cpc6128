"""QLIB math oracle: exhaustive 8-bit mathematical reference, not Z80 ROM execution."""
import json
from pathlib import Path

def signed8(x):
    return x-256 if x&128 else x

def signed16(x):
    return x-65536 if x&32768 else x

def mul_s8(a,b):
    return signed8(a)*signed8(b)

def mat2(m,v):
    return (mul_s8(m[0],v[0])+mul_s8(m[1],v[1]),
            mul_s8(m[2],v[0])+mul_s8(m[3],v[1]))

def verify():
    count=0
    for a in range(256):
        for b in range(256):
            assert ((a+b)&255)==((a+b)%256)
            assert ((a-b)&255)==((a-b)%256)
            p=a*b
            assert 0<=p<=65535 and p==(p&65535)
            if b:
                q,r=divmod(a,b)
                assert 0<=q<=255 and 0<=r<b and a==q*b+r
            assert -16384 <= mul_s8(a,b) <= 16384
            count += 1
    assert mat2((1,2,3,4),(6,8))==(22,50)
    assert mat2((255,2,3,252),(4,251))==(-14,32)
    assert signed16(0x8000)==-32768 and signed16(0x7fff)==32767
    return count

if __name__=="__main__":
    n=verify()
    result={"status":"PASS","input_pairs":n,"scope":"host mathematical oracle, NOT CPC execution"}
    print(json.dumps(result))
