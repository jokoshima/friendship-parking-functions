"""

"""
def possible_outcomes(n):
    invs = []
    for p in Permutations(n-1):
        if p.inverse() == p:
            invs.append(p)

    outcomes = []
    for inv in invs:
        cyc = inv.to_cycles()
        out = [1]
        for tr in cyc:
            if len(tr) == 2:
                out.append(tr[1]+1)
            out.append(tr[0]+1)
        outcomes.append(out)
    return outcomes

"""

"""
def graphs_per_outcome(out):
    # Initialization adjusted to not have to consider car 1
    n = len(out)
    street = [0]*n
    street[0] = 1
    queue = sorted(list(zip(out, list(range(n)))))[1:]
    claws = []

    for car, pos in queue:
        old_pos = pos
        street[pos] = car
        # Looking for first Fibonacci start (incomprehensible :C)
        if pos == 1 or (pos == 2 and street[1] == 0):
            cars_behind = sum([int(street[i] < car and street[i] != 0) for i in range(old_pos+2, n)])
            claws.append(2^cars_behind)
            continue
        if street[pos-1] >= 2 and street[pos-2] == 0:
            if street[pos-3] == 1:
                cars_behind = sum([int(street[i] < car and street[i] != 0) for i in range(old_pos+2, n)])
                claws.append(2^cars_behind)
                continue
            pos -= 1
        if street[pos-1] == 0 and street[pos-2] != 1:
            # go 3 back if there is a car there, go 4 back if there isn't
            pos -= (3 + int(street[pos-3] == 0)) 
        else:
            pos -= 2

        # Walking gaps for Fibonacci (no gap is F3 = 2)
        fib = 0
        gap = False
        for i in range(pos, -1, -1):
            if not gap: # and street[i] != 0 (redundant)
                fib += 1
                gap = True
            elif gap and street[i] == 0:
                gap = False
            elif gap and street[i] != 0:
                claws.append(fibonacci(fib + 2))
                fib = 1
                gap = True
        claws.append(fibonacci(fib + 2))

        # Get the cars you never interact with - all 2 because the connection is free
        cars_behind = sum([int(street[i] < car and street[i] != 0) for i in range(old_pos+2, n)])
        claws.append(2^cars_behind)
    return prod(claws)

# total = 1
# for out in outcomes:
#     total *= graphs_per_outcome_count(out)
# print(total)

print(graphs_per_outcome([1,9,2,3,8,4,5,7,6]))
print(graphs_per_outcome([1,8,2,9,3,7,4,6,5]))