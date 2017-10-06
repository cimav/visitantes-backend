# coding=utf-8
import mysql.connector
from mysql.connector import errorcode

try:
    cnnNetmultixFuente = mysql.connector.connect(
	    user='netmultix',
		password='N3tMult1x@CIMAV',
		host='10.0.0.13',
		database='netmultix')

    conxCimavNetmultixDestino = mysql.connector.connect(
        user='netmultix',
    	password='N3tMult1x@CIMAV',
    	host='10.0.0.13',
    	database='cimavnetmultix'
    )

    curFuente = cnnNetmultixFuente.cursor()

    curDestino = conxCimavNetmultixDestino.cursor()


    curDestino.execute("SELECT count(*) FROM information_schema.tables WHERE table_schema = 'cimavnetmultix' AND table_name = 'personas'; ")
    result= curDestino.fetchone()
    existeTablaPersonas = result[0] == 1

    sql_stmt_extraer =  """SELECT  DISTINCT 0 as id, pv01_clave as clave, 2 as tipo,  PV01_NOMBRE as nombre, CO05_UBICACION as sede
        FROM  netmultix.co05, netmultix.pv01
                    WHERE CO05_CVE_PROV =PV01_CLAVE
                    AND CO05_PEDIDO IN ( SELECT   CO06A_PEDIDO FROM netmultix.co06a WHERE ( CO06A_CANT_PED - CO06A_CANT_REC) >= 0 and CO06A_PARTIDA = '33901' and CO06A_STATUS < 7)
                    GROUP BY clave
                  UNION
                    select 0 as id, no01_cve_emp as clave, 1 as tipo, NO01_NOM_EMP as nombre, NO01_UBICACION as sede from netmultix.no01 where NO01_STATUS = 'A'
                  ORDER BY tipo, sede, nombre;"""


    if not existeTablaPersonas:
        curDestino.execute("""CREATE TABLE personas (
                id INT NOT NULL,
                clave VARCHAR(20),
                tipo INT,
                nombre VARCHAR(200),
                sede INT,
                PRIMARY KEY (id)
            ) CHARSET utf8 COLLATE utf8_spanish_ci;
        """)

        # curNetmultix.execute("""delimiter // """)

        curDestino.execute("""DROP TRIGGER IF EXISTS id_for_personas;""")

        curDestino.execute("""
            CREATE TRIGGER id_for_personas BEFORE INSERT ON personas
            FOR EACH ROW
            BEGIN
              if NEW.tipo = 1 THEN
                set NEW.id = CAST(NEW.clave AS INTEGER);
              ELSEIF NEW.tipo = 2 THEN
                set NEW.id = CAST(NEW.clave AS INTEGER) + 10000;
              END IF;
            END;
         """)

# CREATE TRIGGER id_for_personas BEFORE INSERT ON personas FOR EACH ROW BEGIN if NEW.tipo = 1 THEN set NEW.id = CAST(NEW.clave AS INTEGER); ELSEIF NEW.tipo = 2 THEN set NEW.id = CAST(NEW.clave AS INTEGER) + 10000; END IF; END;

        # curNetmultix.execute(""" delimiter ;""")

        # print('1> ', sql_stmt);

        curDestino.execute("""insert into personas """ + sql_stmt_extraer)

    else:

        curFuente.execute(sql_stmt_extraer)

        for empleado_proveedor in curFuente.fetchall():

            clave = empleado_proveedor[1].strip()
            curDestino.execute("""SELECT * FROM personas WHERE clave = '%s';""" % (clave))
            existePersona = curDestino.fetchone()

            if existePersona is None:

                tipo = empleado_proveedor[2]
                nombre = empleado_proveedor[3].strip()
                sede = empleado_proveedor[4]

                sql_insert = """INSERT INTO personas VALUES (0,'%s',%s,'%s',%s);""" % (clave,tipo,nombre,sede)

                # print('2> ', sql_insert)

                curDestino.execute(sql_insert)


    curDestino.close()
    curFuente.close()
    conxCimavNetmultixDestino.commit()
    conxCimavNetmultixDestino.close()
    cnnNetmultixFuente.close()

except mysql.connector.Error as e:
	print(e)
