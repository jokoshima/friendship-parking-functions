
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

def pf_is_friendly(pf, graph):
    n = len(pf)
    out = [0]*n
    for i in range(n):
        fail = True
        for j in range(pf[i]-1, n):
            left = max(0, j-1)
            right = min(j+1, n-1)
            if out[j] == 0 and (out[left] == 0 or out[left] in graph[i+1]) and (out[right] == 0 or out[right] in graph[i+1]):
                out[j] = i+1
                fail = False
                break
        if fail: 
            return False
    return True

def all_pfs_for_graph(graph):
    n = graph.order()
    pfs = [numtopf(i,n) for i in range((n+1)^(n-1))]
    graph_pfs = []

    for pf in pfs:
        if pf_is_friendly(pf, graph):
            graph_pfs.append(pf)
    return graph_pfs

def all_paths_for_pf(pf):
    n = len(pf)
    labelings = list(Permutations(n))
    paths = []
    for label in labelings:
        graph = Graph([(label[i], label[i+1]) for i in range(n-1)])
        if pf_is_friendly(pf, graph):
            paths.append(label)
    return paths

def outcome(pf):
    n = len(pf)
    outcome = [0]*n
    for i in range(n):
        for j in range(pf[i]-1, n):
            if not outcome[j]:
                outcome[j] = i+1
                break
    return outcome

def displacement(pf):
    out = outcome(pf)
    tagged = sorted(list(zip(out, list(range(len(pf))))))
    return [tagged[i][1]+1 - pf[i] for i in range(len(pf))]

n = 4
# pfs = [numtopf(i,n) for i in range((n+1)^(n-1))]
# for pf in pfs:
#     paths = all_paths_for_pf(pf)
#     print(pf, "->", ["--".join([str(v) for v in path]) for path in paths])
pf = [2,4,2,1]
print(outcome(pf))
print(displacement(pf))