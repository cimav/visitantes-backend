# coding=utf-8
import mysql.connector
from mysql.connector import errorcode

try:
    cnnNetmultix = mysql.connector.connect(
		user='netmultix',
		password='N3tMult1x@CIMAV',
		host='10.0.0.13',
		database='netmultix')

    curNetmultix = cnnNetmultix.cursor()

    curNetmultix.execute("SELECT count(*) FROM information_schema.tables WHERE table_schema = 'netmultix' AND table_name = 'personas' ")
    result= curNetmultix.fetchone()
    existePersonas = result[0] == 1

    if not existePersonas:
        curNetmultix.execute("""CREATE TABLE personas (
                id INT NOT NULL,
                clave VARCHAR(20),
                tipo INT,
                nombre VARCHAR(200),
                sede INT,
                PRIMARY KEY (id)
            ) CHARSET utf8 COLLATE utf8_spanish_ci;
        """)

        # curNetmultix.execute("""delimiter // """)

        curNetmultix.execute("""DROP TRIGGER IF EXISTS id_for_personas;""")

        curNetmultix.execute("""
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

        # curNetmultix.execute(""" delimiter ;""")

        curNetmultix.execute("""
            insert into personas
                SELECT  DISTINCT 0 as id, pv01_clave as clave, 2 as tipo,  PV01_NOMBRE as nombre, CO05_UBICACION as sede FROM  co05,pv01
                WHERE CO05_CVE_PROV =PV01_CLAVE
                AND CO05_PEDIDO IN ( SELECT   CO06A_PEDIDO FROM co06a WHERE ( CO06A_CANT_PED - CO06A_CANT_REC) >= 0 and CO06A_PARTIDA = '33901' and CO06A_STATUS < 7)
                GROUP BY clave
            union
                select 0 as id, no01_cve_emp as clave, 1 as tipo, NO01_NOM_EMP as nombre, NO01_UBICACION as sede from no01 where NO01_STATUS = 'A'
            ORDER BY tipo, sede, nombre;
        """)

    curNetmultix.close()
    cnnNetmultix.commit()
    cnnNetmultix.close()

except mysql.connector.Error as e:
	print(e)
