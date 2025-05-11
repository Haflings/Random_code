import math
import random

global PRIMES
PRIMES = None

def extended_gcd(a, b):
    if a == 0:
        return b, 0, 1
    gcd, x1, y1 = extended_gcd(b % a, a)
    x = y1 - (b // a) * x1
    y = x1
    return gcd, x, y

def mod_inverse(e, phi):
    gcd, x, _ = extended_gcd(e, phi)
    if gcd != 1:
        raise Exception("Modular inverse doesn't exist")
    else:
        return x % phi


def shuffle(l):
    return random.sample(l, len(l))


def GeneratePrime():
    global PRIMES
    
    if PRIMES:
        return random.choice(PRIMES)
    
    PRIMES = [x for x in range(2, 2000)]
    
    for a in PRIMES:
        for b in PRIMES:
            if b > a and b % a == 0:
                PRIMES.remove(b)
    
    return random.choice(PRIMES)

class RSA():
    def mod_exp(self, base, power, modulus):
        '''
        Computes smallest c such that
        
        c = (base ** power) % modulus
        '''
        
        c = 1
        e_d = 0
        
        while e_d < power:
            e_d += 1
            c = (base * c) % modulus
        
        return c
    
    def encrypt(self, m):
        return self.mod_exp(m, self.e, self.N)
    
    def decrypt(self, c):
        return self.mod_exp(c, self.d, self.N)
    
    def __init__(self, p=None, q=None):
        if not p or q:
            p = GeneratePrime()
            q = GeneratePrime()
            
        self.N = p * q
        self.t = (p - 1) * (q - 1)
        self.e = 0
        
        for e in (list(range(2, self.t))):
            if math.gcd(e, self.t) == 1:
                self.e = e
                break
        
        self.d = mod_inverse(self.e, self.t)

# ---------------------------------------------------------------
# TEST

R = RSA()
x = R.encrypt(210391)
print(x)
print(R.decrypt(x))

# ---------------------------------------------------------------
