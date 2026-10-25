def small_neighbour_seq(perm):
    sns = [0]*len(perm)
    for i in range(len(perm)):
        for j in range(i, -1, -1):
            if perm[j] <= perm[i]:
                sns[perm[i]-1] += 1
            else:
                break
    return sns

def small_neighbour_image(n):
    image = set()
    perms = Permutations(n)
    for perm in perms:
        image.add(tuple(small_neighbour_seq(list(perm))))
    return list(image)

"""
Alias of small_neighbour_seq.
(is this how you do aliases?)
"""
def blocking_sequence(perm):
    return small_neighbour_seq(perm)

def outcome(pf):
    out = [0]*len(pf)
    for i in range(len(pf)):
        for j in range(pf[i]-1, len(pf)):
            if out[j] == 0:
                out[j] == i+1
                break
    return out

image4 = small_neighbour_image(4)
image5 = small_neighbour_image(5)
prefixes = {tuple(pf):[] for pf in image4}
for pf in image5:
    prefixes[tuple(pf[:4])].append(pf)
for key in prefixes.keys():
    print(key)
    print(prefixes[key])
# print(i, len(lol), factorial(i) - len(lol), len(lol) / factorial(i))
# print(*lol, sep = "\n")
# print("#"*30)

