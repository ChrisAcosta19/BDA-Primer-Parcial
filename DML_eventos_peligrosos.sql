USE `grupo_1_eventos_peligrosos` ;

-- tratado de nulos
SET SQL_SAFE_UPDATES = 0;
UPDATE tmp_eventos_peligrosos
SET `NIVEL DEL INF` = "Desconocido"
WHERE `NIVEL DEL INF` IS NULL;

UPDATE tmp_eventos_peligrosos
SET `CATEGORÍA DE VÍA` = "Desconocido"
WHERE `CATEGORÍA DE VÍA` IS NULL;

UPDATE tmp_eventos_peligrosos
SET `Estado actual de la vía o del INF` = 'Desconocido'
WHERE `Estado actual de la vía o del INF` IS NULL;
SET SQL_SAFE_UPDATES = 1;

-- llenado de tablas del modelo
INSERT INTO Provincia (provincia_id, provincia)
SELECT DISTINCT `CODIFICACION PROVINCIAL`,`PROVINCIA`
FROM tmp_eventos_peligrosos
ORDER BY `CODIFICACION PROVINCIAL`;

INSERT INTO Canton (canton_id, canton)
SELECT DISTINCT `CODIFICACION CANTONAL`,`CANTON`
FROM tmp_eventos_peligrosos
ORDER BY `CODIFICACION CANTONAL`;

SET SQL_SAFE_UPDATES = 0;
UPDATE tmp_eventos_peligrosos AS tep
JOIN (
    SELECT `CODIFICACION PARROQUIAL`, MIN(`PARROQUIAS`) AS parroquia_normalizada
    FROM tmp_eventos_peligrosos
    GROUP BY `CODIFICACION PARROQUIAL`
) AS sub
ON tep.`CODIFICACION PARROQUIAL` = sub.`CODIFICACION PARROQUIAL`
SET tep.`PARROQUIAS` = sub.parroquia_normalizada;
SET SQL_SAFE_UPDATES = 1;

INSERT INTO Parroquia (parroquia_id, parroquia)
SELECT DISTINCT `CODIFICACION PARROQUIAL`,`PARROQUIAS`
FROM tmp_eventos_peligrosos
ORDER BY `CODIFICACION PARROQUIAL`;

INSERT INTO Tipo (tipo)
SELECT DISTINCT `EVENTO`
FROM tmp_eventos_peligrosos
ORDER BY `EVENTO`;

SET SQL_SAFE_UPDATES = 0;
UPDATE tmp_eventos_peligrosos
SET `CAUSA` = "Oleaje"
WHERE `CAUSA` IN ("Oleaje ");
SET SQL_SAFE_UPDATES = 1;

INSERT INTO Causa (causa)
SELECT DISTINCT `CAUSA`
FROM tmp_eventos_peligrosos
ORDER BY `CAUSA`;

SET SQL_SAFE_UPDATES = 0;
UPDATE tmp_eventos_peligrosos
SET `CATEGORIA DEL EVENTO` = "Época Lluviosa"
WHERE `CATEGORIA DEL EVENTO` IN ("Época Lluviosa ");
SET SQL_SAFE_UPDATES = 1;

INSERT INTO Categoria (categoria)
SELECT DISTINCT `CATEGORIA DEL EVENTO`
FROM tmp_eventos_peligrosos
ORDER BY `CATEGORIA DEL EVENTO`;

INSERT INTO Nivel_del_inf (nivel_del_inf)
SELECT DISTINCT `NIVEL DEL INF`
FROM tmp_eventos_peligrosos
ORDER BY `NIVEL DEL INF`;

INSERT INTO Categoria_via (categoria_via)
SELECT DISTINCT `CATEGORÍA DE VÍA`
FROM tmp_eventos_peligrosos
ORDER BY `CATEGORÍA DE VÍA`;

INSERT INTO Calificacion (calificacion)
SELECT DISTINCT `calificación del evento peligroso`
FROM tmp_eventos_peligrosos
ORDER BY `calificación del evento peligroso`;

INSERT INTO Estado_actual_via_o_inf (estado_actual_via_o_inf)
SELECT DISTINCT `Estado actual de la vía o del INF`
FROM tmp_eventos_peligrosos
ORDER BY `Estado actual de la vía o del INF`;

-- creacion de nuevas columnas en tabla temporal
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE tmp_eventos_peligrosos
ADD COLUMN calificacion_id INT;

UPDATE tmp_eventos_peligrosos tmp
JOIN calificacion cal
ON tmp.`calificación del evento peligroso` = cal.`calificacion`
SET tmp.calificacion_id = cal.calificacion_id;

ALTER TABLE tmp_eventos_peligrosos
ADD COLUMN categoria_id INT;

UPDATE tmp_eventos_peligrosos tmp
JOIN categoria cat
ON tmp.`CATEGORIA DEL EVENTO` = cat.`categoria`
SET tmp.categoria_id = cat.categoria_id;

ALTER TABLE tmp_eventos_peligrosos
ADD COLUMN categoria_via_id INT;

UPDATE tmp_eventos_peligrosos tmp
JOIN categoria_via catv
ON tmp.`CATEGORÍA DE VÍA` = catv.`categoria_via`
SET tmp.categoria_via_id = catv.categoria_via_id;

ALTER TABLE tmp_eventos_peligrosos
ADD COLUMN causa_id INT;

UPDATE tmp_eventos_peligrosos tmp
JOIN causa ca
ON tmp.`CAUSA` = ca.`causa`
SET tmp.causa_id = ca.causa_id;

ALTER TABLE tmp_eventos_peligrosos
ADD COLUMN estado_actual_via_o_inf_id INT;

UPDATE tmp_eventos_peligrosos tmp
JOIN estado_actual_via_o_inf e
ON tmp.`Estado actual de la vía o del INF` = e.`estado_actual_via_o_inf`
SET tmp.estado_actual_via_o_inf_id = e.estado_actual_via_o_inf_id;

ALTER TABLE tmp_eventos_peligrosos
ADD COLUMN nivel_del_inf_id INT;

UPDATE tmp_eventos_peligrosos tmp
JOIN nivel_del_inf n
ON tmp.`NIVEL DEL INF` = n.`nivel_del_inf`
SET tmp.nivel_del_inf_id = n.nivel_del_inf_id;

ALTER TABLE tmp_eventos_peligrosos
ADD COLUMN tipo_id INT;

UPDATE tmp_eventos_peligrosos tmp
JOIN tipo t
ON tmp.`EVENTO` = t.`tipo`
SET tmp.tipo_id = t.tipo_id;
SET SQL_SAFE_UPDATES = 1;

-- insercion de datos en tabla evento
INSERT INTO evento (
provincia_id,
 canton_id,
 parroquia_id,
 causa_id,
 calificacion_id,
 categoria_id,
 tipo_id,
 categoria_via_id,
 estado_actual_via_o_inf_id,
 nivel_del_inf_id,
 comunidad_barrio_sector,
 latitud,
 longitud,
 fecha,
 numero_informe_provincial,
 fallecidas,
 heridas,
 personas_desaparecidas,
 familias_afectadas,
 personas_afectadas_directamente,
 afectadas_indirectas,
 familias_damnificadas,
 personas_damnificadas,
 personas_evacuadas,
 personas_albergadas,
 p_en_familias_acogientes,
 p_en_otros_medios,
 p_en_proceso_evacuacion,
 p_resisten_evacuacion,
 viviendas_afectadas,
 viviendas_destruidas,
 establecimientos_educativos_afectados,
 establecimientos_educativos_destruidos,
 centros_salud_afectados,
 centros_salud_destruidos,
 puentes_afectados,
 puentes_destruidos,
 bienes_publicos_afectados,
 bienes_publicos_destruidos,
 bienes_privados_afectados,
 bienes_privados_destruidos,
 metros_lineales_vias_afectadas,
 ha_cultivo_afectadas,
 ha_cultivo_perdidas,
 ha_cobertura_vegetal_quemada,
 animales_afectados,
 animales_muertos,
 descripcion_general,
 macroevento,
 via_alterna
 )
SELECT `CODIFICACION PROVINCIAL`,
 `CODIFICACION CANTONAL`,
 `CODIFICACION PARROQUIAL`,
  `causa_id`,
   `calificacion_id`,
    `categoria_id`,
     `tipo_id`,
      `categoria_via_id`,
       `estado_actual_via_o_inf_id`,
        `nivel_del_inf_id`,
         `COMUNIDAD/BARRIO/SECTOR`,
         `LATITUD`,
         `LONGITUD`,
         `FECHA DEL EVENTO`,
         `NUMERO DE INFORME PROVINCIAL`,
         `FALLECIDAS`,
         `HERIDAS`,
         `PERSONAS DESAPARECIDAS`,
         `FAMILIAS AFECTADAS`,
         `PERSONAS AFECTADAS DIRECTAMENTE`,
         `AFECTADAS INDIRECTAS`,
         `FAMILIAS DAMNIFICADAS`,
         `PERSONAS DAMNIFICADAS`,
         `PERSONAS EVACUADAS`,
         `PERSONAS ALBERGADAS`,
         `P. EN FAMILIAS ACOGIENTES`,
         `PERSONAS EN OTROS MEDIOS`,
         `PERSONAS EN PROCESO DE EVACUACION`,
         `PERSONAS QUE RESISTEN A LA EVACUACION`,
         `VIVIENDAS AFECTADAS`,
         `VIVIENDAS DESTRUIDAS`,
         `ESTABLECIMIENTOS EDUCATIVOS AFECTADOS`,
         `ESTABLECIMIENTOS EDUCATIVOS DESTRUIDOS`,
         `CENTROS DE SALUD AFECTADOS`,
         `CENTROS DE SALUD DESTRUIDOS`,
         `PUENTES AFECTADOS`,
         `PUENTES DESTRUIDOS`,
         `BIENES PUBLICOS AFECTADOS`,
         `BIENES PUBLICOS DESTRUIDOS`,
         `BIENES PRIVADOS AFECTADOS`,
         `BIENES PRIVADOS DESTRUIDOS`,
         `METROS LINEALES DE VÍAS AFECTADAS`,
         `Ha. CULTIVO AFECTADAS`,
         `Ha. CULTIVO PERDIDAS`,
         `Ha. DE COBERTURA VEGETAL QUEMADA`,
         `ANIMALES AFECTADOS`,
         `ANIMALES MUERTOS`,
         `DESCRIPCIÓN GENERAL DEL EVENTO`,
         `Macroevento`,
         `Vía Alterna`
FROM tmp_eventos_peligrosos;

DROP TABLE IF EXISTS tmp_eventos_peligrosos;