USE `grupo_1_eventos_peligrosos` ;

-- Rol Administraador (DBA)
CREATE ROLE admin_eventos;
GRANT ALL PRIVILEGES ON grupo_1_eventos_peligrosos.* TO admin_eventos WITH GRANT OPTION;
CREATE USER 'admin1'@'localhost' IDENTIFIED BY 'AdminPass123!';
GRANT admin_eventos TO 'admin1'@'localhost';
SET DEFAULT ROLE admin_eventos TO 'admin1'@'localhost';

-- Rol Analista de Datos (Data Analyst)
CREATE ROLE analista_eventos;
USE grupo_1_eventos_peligrosos;
CREATE OR REPLACE VIEW vista_eventos_publicos AS
SELECT 
    evento_id, provincia_id, canton_id, parroquia_id, causa_id,
    calificacion_id, categoria_id, tipo_id, categoria_via_id,
    estado_actual_via_o_inf_id, nivel_del_inf_id,
    comunidad_barrio_sector, fecha, numero_informe_provincial,
    fallecidas, heridas, personas_desaparecidas,
    familias_afectadas, personas_afectadas_directamente,
    afectadas_indirectas, familias_damnificadas, personas_damnificadas,
    personas_evacuadas, personas_albergadas, p_en_familias_acogientes,
    p_en_otros_medios, p_en_proceso_evacuacion, p_resisten_evacuacion,
    viviendas_afectadas, viviendas_destruidas,
    establecimientos_educativos_afectados, establecimientos_educativos_destruidos,
    centros_salud_afectados, centros_salud_destruidos,
    puentes_afectados, puentes_destruidos,
    bienes_publicos_afectados, bienes_publicos_destruidos,
    bienes_privados_afectados, bienes_privados_destruidos,
    metros_lineales_vias_afectadas, ha_cultivo_afectadas,
    ha_cultivo_perdidas, ha_cobertura_vegetal_quemada,
    animales_afectados, animales_muertos,
    descripcion_general, macroevento, via_alterna
FROM evento;
GRANT SELECT ON grupo_1_eventos_peligrosos.vista_eventos_publicos TO analista_eventos;
GRANT SELECT ON grupo_1_eventos_peligrosos.calificacion TO analista_eventos;
GRANT SELECT ON grupo_1_eventos_peligrosos.categoria TO analista_eventos;
GRANT SELECT ON grupo_1_eventos_peligrosos.categoria_via TO analista_eventos;
GRANT SELECT ON grupo_1_eventos_peligrosos.causa TO analista_eventos;
GRANT SELECT ON grupo_1_eventos_peligrosos.estado_actual_via_o_inf TO analista_eventos;
GRANT SELECT ON grupo_1_eventos_peligrosos.nivel_del_inf TO analista_eventos;
GRANT SELECT ON grupo_1_eventos_peligrosos.parroquia TO analista_eventos;
GRANT SELECT ON grupo_1_eventos_peligrosos.canton TO analista_eventos;
GRANT SELECT ON grupo_1_eventos_peligrosos.provincia TO analista_eventos;
GRANT SELECT ON grupo_1_eventos_peligrosos.tipo TO analista_eventos;
CREATE USER 'analista1'@'localhost' IDENTIFIED BY 'AnalistaPass123!';
GRANT analista_eventos TO 'analista1'@'localhost';
SET DEFAULT ROLE analista_eventos TO 'analista1'@'localhost';