def numtopf(num, n=False):
    if not n:
        k = 1
        while (k+1)^(k-1) < num:
            k += 1
        n = k
    digits = [(num//((n+1)^j))%(n+1) for j in range(n-1)]
    digits.reverse()
    pps = [[(i+1+sum(digits[0:j]))%(n+1) for j in range(n)] for i in range(n)]
    for pp in pps:
        wipp = sorted(pp)
        ispf = all([wipp[i] <= i+1 for i in range(n)])
        if 0 not in wipp and ispf:
            return pp
    return "ERROR"

def outcome_is_stinky(out, r):
    n = len(out)
    valid = True
    indices = [pair[1] for pair in sorted(list(zip(out, list(range(n)))))]
    street = [1] + [0]*(n-1)

    # Keys are positions, values are sets of cars within radius of position
    # Should ideally be filled out dynamically in the for - easy to check conditions
    cars_in_radius = {i:set() for i in range(n)}
    # See if you can remove this for by starting the big for at 0
    for i in range(min(r+1, n)):
        cars_in_radius[i].add(1)

    for i in range(1, n):
        #print(cars_in_radius)
        empties = [j for j in range(indices[i]) if street[j] == 0]
        # We need (not <=) instead of (>) because our landing spot might have friendly cars to its right 
        # {} !> {}, so this also checks if this spot is not too far away from everyone
        conds = [not (cars_in_radius[e] <= cars_in_radius[indices[i]]) for e in empties]
        
        if all(conds):
            street[indices[i]] = i+1
            for j in range(max(indices[i]-r, 0), min(indices[i]+r+1, n)):
                cars_in_radius[j].add(i+1)
        else:
            valid = False
            break
    return valid

def all_stinky_outcomes(n, r):
    outs = Permutations(n-1)
    stinky_outs = []
    for p in outs:
        out = [1] + [i+1 for i in p]
        if outcome_is_stinky(out, r):
            stinky_outs.append(out)
    return stinky_outs

# table = []
# for r in range(1, 7):
#     row = []
#     for n in range(3, 11):
#         count = len(all_stinky_outcomes(n,r))
#         print(n, r, count)
#         row.append(str(count))
#     table.append(' & '.join(row))
# print(' \\\\ \n'.join(table))
print(all_stinky_outcomes(5,2))