load("UOV.sage")
def DirectAttack(d, p, v, o, m, q):
    start_time = time.perf_counter()
    n = v + o
    k = n - m                       # число фиксируемых переменных
    Field = GF(q)
    h = Hash(d, Field, m)

    names = [f"x{i}" for i in range(1, n + 1)]
    R = PolynomialRing(Field, names)
    system_polys = [p[i] - h[i] for i in range(m)]
    
    if n <= m:
        try:
            I = R.ideal(system_polys)
            sols = I.variety()
            if sols:
                sol = sols[0]
                end_time = time.perf_counter()
                print(f"Время выполнения: {end_time - start_time:.4f} секунд")
                return vector(Field, [sol[R.gen(i)] for i in range(n)])
            return None
        except Exception as e:
            print(f"Ошибка: {e}")
            return None
        
    while True:
        constraints = [R.gen(j) - Field.random_element() for j in range(k)]
        try:
            sols = R.ideal(system_polys + constraints).variety()
        except Exception:
            continue
        if sols:
            sol = sols[0]
            
            end_time = time.perf_counter()
            execution_time = end_time - start_time
            print(f"Время выполнения: {execution_time:.4f} секунд")
            return vector(Field, [sol[R.gen(i)] for i in range(n)])
msg = "pls dont eat me"
v = [3, 7, 8, 7]
o = [2, 4, 5, 6]
m = [2, 5, 5, 5]
q = [3, 11, 13, 7]

for i in range(len(v)):
    n = v[i] + o[i]
    complexity = q[i] ** (n - m[i])

    print("=" * 70)
    print(f"ТЕСТ {i+1}: v={v[i]}, o={o[i]}, m={m[i]}, q={q[i]}")
    print(f"n = {n}, n - m = {n - m[i]}, сложность = {q[i]}^{n - m[i]} = {complexity}")
    print("=" * 70)

    S, f, p, P = KeyGen(v[i], o[i], m[i], q[i])

    x = Sign(f, S, v[i], o[i], m[i], msg)
    if x is not None:
        ver = Verify(msg, x, P)
        print(f"Подпись: {x}")
        print(f"Подлинность: {ver}")
    print()

    x_att = DirectAttack(msg, p, v[i], o[i], m[i], q[i])
    if x_att is not None:
        ver_att = Verify(msg, x_att, P)
        print(f"Подставная подпись: {x_att}")
        print(f"Подлинность: {ver_att}")
    else:
        print("Атака не удалась")
    print("\n\n\n")
