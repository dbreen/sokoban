import sys

def pad(map):
    size = max(*[len(l) for l in map])
    return [l + (" "*(size-len(l))) for l in map]

def parse(f):
    maps = []
    current = []
    for line in f.readlines():
        if line[0] == ';': continue
        if len(line.strip()):
            current.append(line.rstrip("\n"))
        elif len(current):
            maps.append(current)
            current = []
    return ["\n".join(pad(map)) for map in maps]

if __name__ == "__main__":
    maps = parse(open(sys.argv[1]))
    try:
        start = int(sys.argv[2])
    except (IndexError, TypeError):
        start = 1
    for i, m in enumerate(maps):
        m = m.replace('$', 'X').replace('.', 'O').replace('@', 'P').replace('+', 'O')
        open("%d.txt" % (start + i), 'w').write(m)

