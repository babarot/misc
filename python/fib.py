def fib2(n):
    if n <= 2:
        return 1
    else:
        return fib2(n-1) + fib2(n-2)

if __name__ == "__main__":
    for i in xrange(1,20):
        print fib2(i),
