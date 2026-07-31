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
