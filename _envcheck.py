import glob, re

# match \begin{env} / \end{env}, ignore lines that are commented (start with optional ws then %)
beg = re.compile(r'\\begin\{([A-Za-z*]+)\}')
end = re.compile(r'\\end\{([A-Za-z*]+)\}')

def strip_comment(line):
    # remove from first unescaped % to end
    out = []
    i = 0
    while i < len(line):
        c = line[i]
        if c == '\\' and i + 1 < len(line):
            out.append(line[i:i+2]); i += 2; continue
        if c == '%':
            break
        out.append(c); i += 1
    return ''.join(out)

for f in sorted(glob.glob('*.tex')):
    if f.startswith('_'):
        continue
    stack = []
    problems = []
    with open(f, encoding='utf-8') as fh:
        for ln, raw in enumerate(fh, 1):
            line = strip_comment(raw)
            # process begins and ends in order of appearance
            for m in re.finditer(r'\\(begin|end)\{([A-Za-z*]+)\}', line):
                kind, env = m.group(1), m.group(2)
                if kind == 'begin':
                    stack.append((env, ln))
                else:
                    if not stack:
                        problems.append(f'  line {ln}: \\end{{{env}}} with NO open environment')
                    elif stack[-1][0] != env:
                        problems.append(f'  line {ln}: \\end{{{env}}} but innermost open is \\begin{{{stack[-1][0]}}} from line {stack[-1][1]}')
                        stack.pop()
                    else:
                        stack.pop()
    if problems or stack:
        print(f'==== {f} ====')
        for p in problems:
            print(p)
        for env, ln in stack:
            print(f'  line {ln}: \\begin{{{env}}} never closed')
