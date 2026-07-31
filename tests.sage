load("UOV.sage")

v = 4
o = 3
m = 3
q = 7

S, f, p, P = KeyGen(v, o, m, q)

message = "Тестовое сообщение"

signature = Sign(f, S, v, o, m, message)

test1 = Verify(message, signature, P)

print("Тест 1")
print("Сообщение:", message)
print("Подпись:", signature)
print("Проверка:", test1)
print()

bad_signature = vector(GF(q), list(signature))

bad_signature[0] = GF(q)(Integer(bad_signature[0]) ^^ 1)

test2 = Verify(message, bad_signature, P)

print("Тест 2")
print("Правильная подпись:", signature)
print("Изменённая подпись:", bad_signature)
print("Проверка:", test2)
