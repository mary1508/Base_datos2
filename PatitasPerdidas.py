import pymssql
import sys
from datetime import datetime

def obtener_conexion():
    """
    Establece y devuelve una conexión a la base de datos con pymssql.
    """
    server = 'KENNYMEN'
    database = 'PatitasPerdidas'
    username = 'sa'
    password = 'kennymen_109'
    
    try:
        conn = pymssql.connect(server=server, user=username, password=password, database=database)
        return conn
    except pymssql.Error as e:
        print(f"Error al conectar a la base de datos: {e}")
        sys.exit(1)

def mostrar_menu_principal():
    print("\nMenú Principal")
    print("1. Refugio")
    print("2. Perritos")
    print("3. Adoptantes")
    print("4. Adopciones")
    print("5. Veterinarios")
    print("6. Vacunas")
    print("7. Visitas Veterinarias")
    print("8. Donaciones")
    print("9. Salir")
    return input("Seleccione una tabla: ")

def mostrar_menu_crud():
    print("\nMenú CRUD")
    print("1. Crear registro")
    print("2. Leer registros")
    print("3. Actualizar registro")
    print("4. Eliminar registro")
    print("5. Volver al menú principal")
    return input("Seleccione una operación: ")

def crud_refugio(conn, opcion):
    if opcion == "1":  # Crear
        nombre = input("Ingrese el nombre del refugio: ")
        direccion = input("Ingrese la dirección: ")
        telefono = input("Ingrese el teléfono: ")
        email = input("Ingrese el email: ")
        with conn.cursor() as cursor:
            query = "INSERT INTO Refugio (Nombre, Direccion, Telefono, Email) VALUES (%s, %s, %s, %s)"
            cursor.execute(query, (nombre, direccion, telefono, email))
            conn.commit()
            print("Registro creado exitosamente.")
    elif opcion == "2":  # Leer
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM Refugio")
            rows = cursor.fetchall()
            print("\nRegistros en la tabla Refugio:")
            for row in rows:
                print(row)
    elif opcion == "3":  # Actualizar
        id_refugio = input("Ingrese el ID del refugio a actualizar: ")
        nombre = input("Nuevo nombre (dejar vacío para mantener el actual): ")
        direccion = input("Nueva dirección (dejar vacío para mantener la actual): ")
        telefono = input("Nuevo teléfono (dejar vacío para mantener el actual): ")
        email = input("Nuevo email (dejar vacío para mantener el actual): ")
        with conn.cursor() as cursor:
            query = """
            UPDATE Refugio
            SET 
                Nombre = COALESCE(NULLIF(%s, ''), Nombre),
                Direccion = COALESCE(NULLIF(%s, ''), Direccion),
                Telefono = COALESCE(NULLIF(%s, ''), Telefono),
                Email = COALESCE(NULLIF(%s, ''), Email)
            WHERE ID_Refugio = %s
            """
            cursor.execute(query, (nombre, direccion, telefono, email, id_refugio))
            conn.commit()
            print("Registro actualizado exitosamente.")
    elif opcion == "4":  # Eliminar
        id_refugio = input("Ingrese el ID del refugio a eliminar: ")
        with conn.cursor() as cursor:
            query = "DELETE FROM Refugio WHERE ID_Refugio = %s"
            cursor.execute(query, (id_refugio,))
            conn.commit()
            print("Registro eliminado exitosamente.")

def crud_perritos(conn, opcion):
    if opcion == "1":  # Crear
        nombre = input("Ingrese el nombre del perrito: ")
        raza = input("Ingrese la raza: ")
        edad = input("Ingrese la edad: ")
        color = input("Ingrese el color: ")
        sexo = input("Ingrese el sexo (M/F): ")
        estado_adopcion = input("Ingrese el estado de adopción: ")
        id_refugio = input("Ingrese el ID del refugio: ")
        with conn.cursor() as cursor:
            query = """
            INSERT INTO Perritos (Nombre, Raza, Edad, Color, Sexo, Estado_Adopcion, ID_Refugio) 
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            """
            cursor.execute(query, (nombre, raza, edad, color, sexo, estado_adopcion, id_refugio))
            conn.commit()
            print("Registro creado exitosamente.")
    elif opcion == "2":  # Leer
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM Perritos")
            rows = cursor.fetchall()
            print("\nRegistros en la tabla Perritos:")
            for row in rows:
                print(row)
    elif opcion == "3":  # Actualizar
        id_perrito = input("Ingrese el ID del perrito a actualizar: ")
        nombre = input("Nuevo nombre (dejar vacío para mantener el actual): ")
        raza = input("Nueva raza (dejar vacío para mantener la actual): ")
        edad = input("Nueva edad (dejar vacío para mantener la actual): ")
        color = input("Nuevo color (dejar vacío para mantener el actual): ")
        sexo = input("Nuevo sexo (dejar vacío para mantener el actual): ")
        estado_adopcion = input("Nuevo estado de adopción (dejar vacío para mantener el actual): ")
        id_refugio = input("Nuevo ID de refugio (dejar vacío para mantener el actual): ")
        with conn.cursor() as cursor:
            query = """
            UPDATE Perritos
            SET 
                Nombre = COALESCE(NULLIF(%s, ''), Nombre),
                Raza = COALESCE(NULLIF(%s, ''), Raza),
                Edad = COALESCE(NULLIF(%s, ''), Edad),
                Color = COALESCE(NULLIF(%s, ''), Color),
                Sexo = COALESCE(NULLIF(%s, ''), Sexo),
                Estado_Adopcion = COALESCE(NULLIF(%s, ''), Estado_Adopcion),
                ID_Refugio = COALESCE(NULLIF(%s, ''), ID_Refugio)
            WHERE ID_Perrito = %s
            """
            cursor.execute(query, (nombre, raza, edad, color, sexo, estado_adopcion, id_refugio, id_perrito))
            conn.commit()
            print("Registro actualizado exitosamente.")
    elif opcion == "4":  # Eliminar
        id_perrito = input("Ingrese el ID del perrito a eliminar: ")
        with conn.cursor() as cursor:
            query = "DELETE FROM Perritos WHERE ID_Perrito = %s"
            cursor.execute(query, (id_perrito,))
            conn.commit()
            print("Registro eliminado exitosamente.")

def crud_adoptantes(conn, opcion):
    if opcion == "1":  # Crear
        nombre = input("Ingrese el nombre del adoptante: ")
        apellido = input("Ingrese el apellido: ")
        dni = input("Ingrese el DNI: ")
        telefono = input("Ingrese el teléfono: ")
        email = input("Ingrese el email: ")
        direccion = input("Ingrese la dirección: ")
        with conn.cursor() as cursor:
            query = """
            INSERT INTO Adoptantes (Nombre, Apellido, DNI_ADOPTANTE, Telefono, Email, Direccion) 
            VALUES (%s, %s, %s, %s, %s, %s)
            """
            cursor.execute(query, (nombre, apellido, dni, telefono, email, direccion))
            conn.commit()
            print("Registro creado exitosamente.")
    elif opcion == "2":  # Leer
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM Adoptantes")
            rows = cursor.fetchall()
            print("\nRegistros en la tabla Adoptantes:")
            for row in rows:
                print(row)
    elif opcion == "3":  # Actualizar
        dni = input("Ingrese el DNI del adoptante a actualizar: ")
        nombre = input("Nuevo nombre (dejar vacío para mantener el actual): ")
        apellido = input("Nuevo apellido (dejar vacío para mantener el actual): ")
        telefono = input("Nuevo teléfono (dejar vacío para mantener el actual): ")
        email = input("Nuevo email (dejar vacío para mantener el actual): ")
        direccion = input("Nueva dirección (dejar vacío para mantener la actual): ")
        with conn.cursor() as cursor:
            query = """
            UPDATE Adoptantes
            SET 
                Nombre = COALESCE(NULLIF(%s, ''), Nombre),
                Apellido = COALESCE(NULLIF(%s, ''), Apellido),
                Telefono = COALESCE(NULLIF(%s, ''), Telefono),
                Email = COALESCE(NULLIF(%s, ''), Email),
                Direccion = COALESCE(NULLIF(%s, ''), Direccion)
            WHERE DNI_ADOPTANTE = %s
            """
            cursor.execute(query, (nombre, apellido, telefono, email, direccion, dni))
            conn.commit()
            print("Registro actualizado exitosamente.")
    elif opcion == "4":  # Eliminar
        dni = input("Ingrese el DNI del adoptante a eliminar: ")
        with conn.cursor() as cursor:
            query = "DELETE FROM Adoptantes WHERE DNI_ADOPTANTE = %s"
            cursor.execute(query, (dni,))
            conn.commit()
            print("Registro eliminado exitosamente.")

def crud_adopciones(conn, opcion):
    if opcion == "1":  # Crear
        id_perrito = input("Ingrese el ID del perrito: ")
        dni_adoptante = input("Ingrese el DNI del adoptante: ")
        fecha = input("Ingrese la fecha de adopción (YYYY-MM-DD): ")
        with conn.cursor() as cursor:
            query = """
            INSERT INTO Adopciones (ID_Perrito, DNI_ADOPTANTE, Fecha_Adopcion) 
            VALUES (%s, %s, %s)
            """
            cursor.execute(query, (id_perrito, dni_adoptante, fecha))
            conn.commit()
            print("Registro creado exitosamente.")
    elif opcion == "2":  # Leer
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM Adopciones")
            rows = cursor.fetchall()
            print("\nRegistros en la tabla Adopciones:")
            for row in rows:
                print(row)
    elif opcion == "3":  # Actualizar
        id_adopcion = input("Ingrese el ID de la adopción a actualizar: ")
        id_perrito = input("Nuevo ID de perrito (dejar vacío para mantener el actual): ")
        dni_adoptante = input("Nuevo DNI de adoptante (dejar vacío para mantener el actual): ")
        fecha = input("Nueva fecha de adopción (YYYY-MM-DD) (dejar vacío para mantener la actual): ")
        with conn.cursor() as cursor:
            query = """
            UPDATE Adopciones
            SET 
                ID_Perrito = COALESCE(NULLIF(%s, ''), ID_Perrito),
                DNI_ADOPTANTE = COALESCE(NULLIF(%s, ''), DNI_ADOPTANTE),
                Fecha_Adopcion = COALESCE(NULLIF(%s, ''), Fecha_Adopcion)
            WHERE ID = %s
            """
            cursor.execute(query, (id_perrito, dni_adoptante, fecha, id_adopcion))
            conn.commit()
            print("Registro actualizado exitosamente.")
    elif opcion == "4":  # Eliminar
        id_adopcion = input("Ingrese el ID de la adopción a eliminar: ")
        with conn.cursor() as cursor:
            query = "DELETE FROM Adopciones WHERE ID = %s"
            cursor.execute(query, (id_adopcion,))
            conn.commit()
            print("Registro eliminado exitosamente.")

def crud_veterinarios(conn, opcion):
    if opcion == "1":  # Crear
        dni = input("Ingrese el DNI del veterinario: ")
        nombre = input("Ingrese el nombre: ")
        apellido = input("Ingrese el apellido: ")
        telefono = input("Ingrese el teléfono: ")
        email = input("Ingrese el email: ")
        direccion = input("Ingrese la dirección: ")
        with conn.cursor() as cursor:
            query = """
            INSERT INTO Veterinarios (DNI_VETERINARIOS, Nombre, Apellido, Telefono, Email, Direccion) 
            VALUES (%s, %s, %s, %s, %s, %s)
            """
            cursor.execute(query, (dni, nombre, apellido, telefono, email, direccion))
            conn.commit()
            print("Registro creado exitosamente.")
    elif opcion == "2":  # Leer
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM Veterinarios")
            rows = cursor.fetchall()
            print("\nRegistros en la tabla Veterinarios:")
            for row in rows:
                print(row)
    elif opcion == "3":  # Actualizar
        dni = input("Ingrese el DNI del veterinario a actualizar: ")
        nombre = input("Nuevo nombre (dejar vacío para mantener el actual): ")
        apellido = input("Nuevo apellido (dejar vacío para mantener el actual): ")
        telefono = input("Nuevo teléfono (dejar vacío para mantener el actual): ")
        email = input("Nuevo email (dejar vacío para mantener el actual): ")
        direccion = input("Nueva dirección (dejar vacío para mantener la actual): ")
        with conn.cursor() as cursor:
            query = """
            UPDATE Veterinarios
            SET 
                Nombre = COALESCE(NULLIF(%s, ''), Nombre),
                Apellido = COALESCE(NULLIF(%s, ''), Apellido),
                Telefono = COALESCE(NULLIF(%s, ''), Telefono),
                Email = COALESCE(NULLIF(%s, ''), Email),
                Direccion = COALESCE(NULLIF(%s, ''), Direccion)
            WHERE DNI_VETERINARIOS = %s
            """
            cursor.execute(query, (nombre, apellido, telefono, email, direccion, dni))
            conn.commit()
            print("Registro actualizado exitosamente.")
    elif opcion == "4":  # Eliminar
        dni = input("Ingrese el DNI del veterinario a eliminar: ")
        with conn.cursor() as cursor:
            query = "DELETE FROM Veterinarios WHERE DNI_VETERINARIOS = %s"
            cursor.execute(query, (dni,))
            conn.commit()
            print("Registro eliminado exitosamente.")

def crud_vacunas(conn, opcion):
    if opcion == "1":  # Crear
        id_vacuna = input("Ingrese el ID de la vacuna: ")
        nombre = input("Ingrese el nombre de la vacuna: ")
        descripcion = input("Ingrese la descripción: ")
        fecha = input("Ingrese la fecha de vacunación (YYYY-MM-DD): ")
        id_perrito = input("Ingrese el ID del perrito: ")
        dni_veterinario = input("Ingrese el DNI del veterinario: ")
        with conn.cursor() as cursor:
            query = """
            INSERT INTO Vacunas (ID, Nombre, Descripcion, Fecha_Vacunacion, ID_Perrito, DNI_VETERINARIOS) 
            VALUES (%s, %s, %s, %s, %s, %s)
            """
            cursor.execute(query, (id_vacuna, nombre, descripcion, fecha, id_perrito, dni_veterinario))
            conn.commit()
            print("Registro creado exitosamente.")
    elif opcion == "2":  # Leer
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM Vacunas")
            rows = cursor.fetchall()
            print("\nRegistros en la tabla Vacunas:")
            for row in rows:
                print(row)
    elif opcion == "3":  # Actualizar
        id_vacuna = input("Ingrese el ID de la vacuna a actualizar: ")
        nombre = input("Nuevo nombre (dejar vacío para mantener el actual): ")
        descripcion = input("Nueva descripción (dejar vacío para mantener la actual): ")
        fecha = input("Nueva fecha (YYYY-MM-DD) (dejar vacío para mantener la actual): ")
        id_perrito = input("Nuevo ID de perrito (dejar vacío para mantener el actual): ")
        dni_veterinario = input("Nuevo DNI de veterinario (dejar vacío para mantener el actual): ")
        with conn.cursor() as cursor:
            query = """
            UPDATE Vacunas
            SET 
                Nombre = COALESCE(NULLIF(%s, ''), Nombre),
                Descripcion = COALESCE(NULLIF(%s, ''), Descripcion),
                Fecha_Vacunacion = COALESCE(NULLIF(%s, ''), Fecha_Vacunacion),
                ID_Perrito = COALESCE(NULLIF(%s, ''), ID_Perrito),
                DNI_VETERINARIOS = COALESCE(NULLIF(%s, ''), DNI_VETERINARIOS)
            WHERE ID = %s
            """
            cursor.execute(query, (nombre, descripcion, fecha, id_perrito, dni_veterinario, id_vacuna))
            conn.commit()
            print("Registro actualizado exitosamente.")
    elif opcion == "4":  # Eliminar
        id_vacuna = input("Ingrese el ID de la vacuna a eliminar: ")
        with conn.cursor() as cursor:
            query = "DELETE FROM Vacunas WHERE ID = %s"
            cursor.execute(query, (id_vacuna,))
            conn.commit()
            print("Registro eliminado exitosamente.")

def crud_visitas_veterinarias(conn, opcion):
    if opcion == "1":  # Crear
        id_perrito = input("Ingrese el ID del perrito: ")
        dni_veterinario = input("Ingrese el DNI del veterinario: ")
        fecha = input("Ingrese la fecha de la visita (YYYY-MM-DD): ")
        descripcion = input("Ingrese la descripción de la visita: ")
        with conn.cursor() as cursor:
            query = """
            INSERT INTO VisitasVeterinarias (ID_Perrito, DNI_VETERINARIOS, Fecha_Visita, Descripcion) 
            VALUES (%s, %s, %s, %s)
            """
            cursor.execute(query, (id_perrito, dni_veterinario, fecha, descripcion))
            conn.commit()
            print("Registro creado exitosamente.")
    elif opcion == "2":  # Leer
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM VisitasVeterinarias")
            rows = cursor.fetchall()
            print("\nRegistros en la tabla Visitas Veterinarias:")
            for row in rows:
                print(row)
    elif opcion == "3":  # Actualizar
        print("Para actualizar una visita, necesitamos identificar el registro específico.")
        id_perrito = input("Ingrese el ID del perrito de la visita a actualizar: ")
        fecha_original = input("Ingrese la fecha original de la visita (YYYY-MM-DD): ")
        
        # Nuevos valores
        nueva_fecha = input("Nueva fecha (YYYY-MM-DD) (dejar vacío para mantener la actual): ")
        nueva_descripcion = input("Nueva descripción (dejar vacío para mantener la actual): ")
        nuevo_dni_veterinario = input("Nuevo DNI de veterinario (dejar vacío para mantener el actual): ")
        
        with conn.cursor() as cursor:
            query = """
            UPDATE VisitasVeterinarias
            SET 
                Fecha_Visita = COALESCE(NULLIF(%s, ''), Fecha_Visita),
                Descripcion = COALESCE(NULLIF(%s, ''), Descripcion),
                DNI_VETERINARIOS = COALESCE(NULLIF(%s, ''), DNI_VETERINARIOS)
            WHERE ID_Perrito = %s AND Fecha_Visita = %s
            """
            cursor.execute(query, (nueva_fecha, nueva_descripcion, nuevo_dni_veterinario, id_perrito, fecha_original))
            conn.commit()
            print("Registro actualizado exitosamente.")
    elif opcion == "4":  # Eliminar
        id_perrito = input("Ingrese el ID del perrito: ")
        fecha = input("Ingrese la fecha de la visita a eliminar (YYYY-MM-DD): ")
        with conn.cursor() as cursor:
            query = "DELETE FROM VisitasVeterinarias WHERE ID_Perrito = %s AND Fecha_Visita = %s"
            cursor.execute(query, (id_perrito, fecha))
            conn.commit()
            print("Registro eliminado exitosamente.")

def crud_donaciones(conn, opcion):
    if opcion == "1":  # Crear
        monto = input("Ingrese el monto de la donación: ")
        fecha = input("Ingrese la fecha de la donación (YYYY-MM-DD): ")
        dni_adoptante = input("Ingrese el DNI del adoptante: ")
        id_refugio = input("Ingrese el ID del refugio: ")
        with conn.cursor() as cursor:
            query = """
            INSERT INTO Donaciones (Monto, Fecha, DNI_ADOPTANTE, ID_Refugio) 
            VALUES (%s, %s, %s, %s)
            """
            cursor.execute(query, (monto, fecha, dni_adoptante, id_refugio))
            conn.commit()
            print("Registro creado exitosamente.")
    elif opcion == "2":  # Leer
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM Donaciones")
            rows = cursor.fetchall()
            print("\nRegistros en la tabla Donaciones:")
            for row in rows:
                print(row)
    elif opcion == "3":  # Actualizar
        print("Para actualizar una donación, necesitamos identificar el registro específico.")
        dni_adoptante = input("Ingrese el DNI del adoptante de la donación a actualizar: ")
        fecha_original = input("Ingrese la fecha original de la donación (YYYY-MM-DD): ")
        
        # Nuevos valores
        nuevo_monto = input("Nuevo monto (dejar vacío para mantener el actual): ")
        nueva_fecha = input("Nueva fecha (YYYY-MM-DD) (dejar vacío para mantener la actual): ")
        nuevo_id_refugio = input("Nuevo ID de refugio (dejar vacío para mantener el actual): ")
        
        with conn.cursor() as cursor:
            query = """
            UPDATE Donaciones
            SET 
                Monto = COALESCE(NULLIF(%s, ''), Monto),
                Fecha = COALESCE(NULLIF(%s, ''), Fecha),
                ID_Refugio = COALESCE(NULLIF(%s, ''), ID_Refugio)
            WHERE DNI_ADOPTANTE = %s AND Fecha = %s
            """
            cursor.execute(query, (nuevo_monto, nueva_fecha, nuevo_id_refugio, dni_adoptante, fecha_original))
            conn.commit()
            print("Registro actualizado exitosamente.")
    elif opcion == "4":  # Eliminar
        dni_adoptante = input("Ingrese el DNI del adoptante: ")
        fecha = input("Ingrese la fecha de la donación a eliminar (YYYY-MM-DD): ")
        with conn.cursor() as cursor:
            query = "DELETE FROM Donaciones WHERE DNI_ADOPTANTE = %s AND Fecha = %s"
            cursor.execute(query, (dni_adoptante, fecha))
            conn.commit()
            print("Registro eliminado exitosamente.")

def main():
    conn = obtener_conexion()
    try:
        while True:
            tabla = mostrar_menu_principal()
            if tabla == "9":
                print("Saliendo del programa...")
                break
            
            while True:
                operacion = mostrar_menu_crud()
                if operacion == "5":
                    break
                
                if tabla == "1":
                    crud_refugio(conn, operacion)
                elif tabla == "2":
                    crud_perritos(conn, operacion)
                elif tabla == "3":
                    crud_adoptantes(conn, operacion)
                elif tabla == "4":
                    crud_adopciones(conn, operacion)
                elif tabla == "5":
                    crud_veterinarios(conn, operacion)
                elif tabla == "6":
                    crud_vacunas(conn, operacion)
                elif tabla == "7":
                    crud_visitas_veterinarias(conn, operacion)
                elif tabla == "8":
                    crud_donaciones(conn, operacion)
                else:
                    print("Opción no válida.")
    finally:
        conn.close()

if __name__ == "__main__":
    main()