# coding=utf-8
import mysql.connector
from mysql.connector import errorcode

try:

    # Copias Originales de NetMultix
    cnnNetmultixFuente = mysql.connector.connect(
	    user='netmultix',
		password='N3tMult1x@CIMAV',
		host='10.0.0.13',
		database='netmultix')
    curFuente = cnnNetmultixFuente.cursor()

    # Replicas para Cimav
    conxCimavNetmultixDestino = mysql.connector.connect(
        user='netmultix',
        password='N3tMult1x@CIMAV',
        host='10.0.0.13',
    	database='cimavnetmultix'
    )
    curDestino = conxCimavNetmultixDestino.cursor()


    # Comprobar si existe la tabla Personas
    curDestino.execute("SELECT count(*) FROM information_schema.tables WHERE table_schema = 'cimavnetmultix' AND table_name = 'personas'; ")
    result= curDestino.fetchone()
    existeTablaPersonas = result[0] == 1

    # Extraer Empleados(vigentes) y Proveedores(subcontrados, validos y vigentes)  del NetMultix en una sola consulta
    # CO06A_PARTIDA = '33901' son los Subcontrados
    # se deja campo nombre por compatibilidad
    sql_stmt_extraer =  """SELECT  DISTINCT 0 as id, pv01_clave as clave, 2 as tipo,  PV01_NOMBRE as nombre, CO05_UBICACION as sede, 0 as departamento_id, '' as cuenta_cimav, '' as apellidos, '' as nombres
        FROM  netmultix.co05, netmultix.pv01
                    WHERE CO05_CVE_PROV =PV01_CLAVE
                    AND CO05_PEDIDO IN ( SELECT   CO06A_PEDIDO FROM netmultix.co06a WHERE ( CO06A_CANT_PED - CO06A_CANT_REC) >= 0 and CO06A_PARTIDA = '33901' and CO06A_STATUS < 7)
                    GROUP BY clave
                  UNION
                    select 0 as id, no01_cve_emp as clave, 1 as tipo, NO01_NOM_EMP as nombre, NO01_UBICACION as sede,
                      CONVERT(SUBSTRING_INDEX(no01_depto,'-',-1),UNSIGNED INTEGER) as departamento_id, LEFT(no01_email60,INSTR(no01_email60,"@")-1)  as cuenta_cimav, concat(trim(no01_apellido_pat), ' ', trim(no01_apellido_mat)) as apellidos, TRIM(no01_nombre) as nombres
                    from netmultix.no01 where NO01_STATUS = 'A'
                  ORDER BY tipo, sede, nombre;"""

    # Si no existe la Tabla Personas todavía (sucede una sola vez)
    if not existeTablaPersonas and False:
        curDestino.execute("""CREATE TABLE personas (
                id INT NOT NULL,
                clave VARCHAR(20),
                tipo INT,
                nombre VARCHAR(200),
                sede INT,
                departamento_id INT,
                cuanta_cimav VARCHAR(120),
                apellidos VARCHAR(60),
                nombres VARCHAR(60),
                PRIMARY KEY (id)
            ) CHARSET utf8 COLLATE utf8_spanish_ci;
        """)

        # curNetmultix.execute("""delimiter // """)

        curDestino.execute("""DROP TRIGGER IF EXISTS id_for_personas;""")

        # Inserta Empleados convirtiendo su Clave en su Id
        # Inserta Proveedores convirtiendo su Clave en su Id y sumándole 10000 para distinguirlos de los Empleados
        curDestino.execute("""
            CREATE TRIGGER id_for_personas BEFORE INSERT ON personas
            FOR EACH ROW
            BEGIN
              if NEW.tipo = 1 THEN  -- Empleados de la Nomina.
                set NEW.id = CAST(NEW.clave AS INTEGER);
              ELSEIF NEW.tipo = 2 THEN
                set NEW.id = CAST(NEW.clave AS INTEGER) + 10000; -- Contratatos partida 33901. Los 10miles
              ELSEIF NEW.tipo = 3 THEN
                set NEW.id = CAST(NEW.clave AS INTEGER) + 0; -- Catedras y otros. Directamente son los 20miles
              END IF;
            END;
         """)

        # CREATE TRIGGER id_for_personas BEFORE INSERT ON personas FOR EACH ROW BEGIN if NEW.tipo = 1 THEN set NEW.id = CAST(NEW.clave AS INTEGER); ELSEIF NEW.tipo = 2 THEN set NEW.id = CAST(NEW.clave AS INTEGER) + 10000; END IF; END;

        # curNetmultix.execute(""" delimiter ;""")

        # print('1> ', sql_stmt);

        # Inserta directo el SQl statement dado que tienen los mismos campos
###        curDestino.execute("""insert into personas """ + sql_stmt_extraer)

    elif True:

        # Si la tabla Personas ya existe

        # jala Empleados y Proveedores
        curFuente.execute(sql_stmt_extraer)

        # los recorre
        for empleado_proveedor in curFuente.fetchall():

            tipo = empleado_proveedor[2]
            nombre = empleado_proveedor[3].strip()
            sede = empleado_proveedor[4]
            depto_id = empleado_proveedor[5]
            cuenta_cimav = empleado_proveedor[6]
            apellidos = empleado_proveedor[7]
            nombres = empleado_proveedor[8]

            # comprueba si la persona ya existe
            clave = empleado_proveedor[1].strip()
            curDestino.execute("""SELECT * FROM personas WHERE clave = '%s';""" % (clave))
            existePersona = curDestino.fetchone()

            if existePersona is None:
                # la Persona No existe; es Inserción

                sql_insert = """INSERT INTO personas VALUES (default,'%s',%s,'%s',%s,%s,'%s','%s','%s');""" % (clave,tipo,nombre,sede,depto_id,cuenta_cimav,apellidos,nombres)
                print '2> ', sql_insert, depto_id
                curDestino.execute(sql_insert)

            else:
                # es Actualización
                sql_update = """UPDATE personas SET tipo=%s, nombre='%s', sede =%s, departamento_id =%s, cuenta_cimav='%s', apellidos='%s', nombres='%s' WHERE clave ='%s';""" % (tipo,nombre,sede,depto_id,cuenta_cimav,apellidos,nombres, clave)
                print '3> ', sql_update
                curDestino.execute(sql_update)

    if False: # Catedras y Especiales. Son los 20miles
        curDestino.execute("""INSERT INTO personas VALUES (default,'%s',%s,'%s',%s,%s,'%s','%s','%s');""" % ('20001',3,'LISSET BERENYSE CHACON GUTIERREZ',4,48,'lisset.chacon','Chacon Gutierrez','Lisset Berenyse'));
        curDestino.execute("""INSERT INTO personas VALUES (default,'%s',%s,'%s',%s,%s,'%s','%s','%s');""" % ('20002',3,'LILIANA REYNOSO CUEVAS',4,48,'liliana.reynoso','Reynoso Cuevas','Liliana'));
        curDestino.execute("""INSERT INTO personas VALUES (default,'%s',%s,'%s',%s,%s,'%s','%s','%s');""" % ('20003',3,'NORMA ALEJANDRA RODRIGUEZ MUÑOZ',4,48,'norma.rodriguez','Rodriguez Muñoz','Norma Alejandra'));
        curDestino.execute("""INSERT INTO personas VALUES (default,'%s',%s,'%s',%s,%s,'%s','%s','%s');""" % ('20004',3,'EDUARDO VENEGAS REYES',4,48,'eduardo.venegas','Venegas Reyes','Eduardo'));
        curDestino.execute("""INSERT INTO personas VALUES (default,'%s',%s,'%s',%s,%s,'%s','%s','%s');""" % ('20005',3,'FERNANDO SOSA MONTEMAYOR',4,48,'fernando.sosa','Sosa Montemayor','Fernando'));
        curDestino.execute("""INSERT INTO personas VALUES (default,'%s',%s,'%s',%s,%s,'%s','%s','%s');""" % ('20006',3,'GABRIELA TAPIA PADILLA',1,12,'gabriela.tapia','Tapia Padilla','Gabriela'));
        curDestino.execute("""INSERT INTO personas VALUES (default,'%s',%s,'%s',%s,%s,'%s','%s','%s');""" % ('20007',3,'JUAN MANUEL PARADELA RODRIGUEZ',4,48,'juan.paradela','Paradela Rodriguez','Juan Manuel'));

    curDestino.close()
    curFuente.close()
    conxCimavNetmultixDestino.commit()
    conxCimavNetmultixDestino.close()
    cnnNetmultixFuente.close()

except mysql.connector.Error as e:
	print(e)
