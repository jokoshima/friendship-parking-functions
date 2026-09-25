def involutions(n):
    invs = []
    for p in Permutations(n):
        if p.inverse() == p:
            invs.append(p)
    return invs

n = 4
invs = involutions(n-1)
outcomes = []
for inv in invs:
    cyc = inv.to_cycles()
    out = [1]
    for tr in cyc:
        if len(tr) == 2:
            out.append(tr[1]+1)
        out.append(tr[0]+1)
    outcomes.append(out)
