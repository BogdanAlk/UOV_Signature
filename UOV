import hashlib

def Hash(msg, Field, m): # по сообщению msg строим его хеш, то есть вектор длины m над полем Field 
    h = hashlib.shake_256(msg.encode()).digest(m)
    return vector(Field, list(h))

def KeyGen(v, o, m, q, verbose = False):
    n = v + o

    names = [f"x{i}" for i in range(1, n + 1)]
    R = PolynomialRing(GF(q), names)
    x = vector(R, R.gens())
    F = []
    f = []

    for i in range(m):
        F1 = random_matrix(GF(q), v, v)
        F2 = random_matrix(GF(q), v, o)

        Z1 = matrix(GF(q), o, v)
        Z2 = matrix(GF(q), o, o)

        F_i = block_matrix([
            [F1, F2],
            [Z1, Z2]
        ])
        F.append(F_i)
        
        f_poly = (x.row() * F_i * x.column())[0, 0]
        f.append(f_poly)
        
    I_v = identity_matrix(GF(q), v)
    I_o = identity_matrix(GF(q), o)

    B = random_matrix(GF(q), v, o)

    Zero = matrix(GF(q), o, v)

    S = block_matrix([
        [I_v, B],
        [Zero, I_o]
    ])
    
    P = []
    p = []

    for i in range(m):
        P_i = S.transpose() * F[i] * S
        P.append(P_i)
        p_poly = (x.row() * P_i * x.column())[0, 0]
        p.append(p_poly)
        
    if verbose:
        print("Секретная матрица отображения:")
        print(S)

        print("\nСекретный ключ:")
        for i in range(m):
            print(f"f{i+1}(x) =", f[i])

        print("\nПубличный ключ:")
        for i in range(m):
            print(f"p{i+1}(x) =", p[i])

    return S, f, p, P

def Sign(f, S, v, o, m, d):
    n = v + o
    q = S.base_ring().order()
    Field = GF(q)
    
    f_copy = [poly for poly in f]
    
    dHash = Hash(d, Field, m)
    
    for i in range(m):
        f_copy[i] = f_copy[i] - dHash[i]
    
    while True:
        rand = [Field.random_element() for _ in range(v)]
        
        f_subst = []
        for i in range(m):
            poly = f_copy[i]
            for j in range(v):
                poly = poly.subs({poly.parent().gen(j): rand[j]})
            f_subst.append(poly)
        
        A = matrix(Field, m, o)
        b = vector(Field, m)
        
        for i in range(m):
            poly = f_subst[i]
            for j, oil_idx in enumerate(range(v, n)):
                coeff = poly.coefficient(poly.parent().gen(oil_idx))
                A[i, j] = coeff
            b[i] = -poly.constant_coefficient()
        
        try:
            oil_vals = A.solve_right(b)
        except ValueError:
            continue
        
        y = []
        for val in rand:
            y.append(val)
        for val in oil_vals:
            y.append(val)
        y = vector(Field, y)
        
        try:
            x_sign = S.solve_right(y)
            return x_sign
        except ValueError:
            continue

def Verify(d, x, P, verbose = False):
    m = len(P)
    n = len(x)
    q = P[0].base_ring().cardinality()
    Field = GF(q)
    h = Hash(d, Field, m)

    ver = True
    for e in range(m):
        lhs = x * P[e] * x
        rhs = h[e]
        if verbose:
            print((f"P{e}: lhs={lhs}, rhs={rhs}"))
        ver = (lhs == rhs)
        if not(ver):
            return False
    return True
