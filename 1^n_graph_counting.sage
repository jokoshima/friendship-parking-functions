"""
Returns all possible outcomes for the parking function 1^n
over the set of all labelled graphs on n vertices.
The code computes these outcomes using a bijection to 
involutions, proven by Aditya Khanna.
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
Given an outcome of the friendship parking function 1^n, returns
the number of labelled graphs on n vertices on which 1^n is
a friendship parking function with that outcome.

This function cannot return the graphs themselves - while it 
is possible to adapt it to do so, that adaptation is complicated, 
and the number of such graphs grows very quickly to be useful.

The function relies on a proof of the count by counting "adjacencies"
in the outcome, and the logic reflects that. The logic for finding
the entry to start counting from, while efficient, is difficult to 
read and might benefit from a more straightforward rewrite.
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



for i in range(15):
    total = []
    outcomes = possible_outcomes(i+1)
    for out in outcomes:
        count = graphs_per_outcome(out)
        total.append(count)
    print(numerical_approx(sum(total) / 2^(binomial(i+1, 2))))
