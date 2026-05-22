import re, glob

defre = re.compile(r'\\(?:newcommand|renewcommand|providecommand|DeclareRobustCommand|def)\s*\*?\s*\{?\\([A-Za-z]+)\}?')

def defs(path):
    d = {}
    with open(path, encoding='utf-8') as fh:
        for ln, line in enumerate(fh, 1):
            s = line.split('%')[0]
            for m in defre.finditer(s):
                d.setdefault(m.group(1), []).append(ln)
    return d

pkg = defs('packages.tex')
for f in ['intro.tex'] + sorted(glob.glob('*.tex')):
    if f in ('packages.tex','main.tex') or f.startswith('_'):
        continue
    try:
        d = defs(f)
    except FileNotFoundError:
        continue
    conflicts = [(name, lns) for name, lns in d.items() if name in pkg]
    if conflicts:
        print(f'== {f} also defines (already in packages.tex): ==')
        for name, lns in conflicts:
            print(f'   \\{name}  at line(s) {lns}  (packages.tex line {pkg[name]})')
