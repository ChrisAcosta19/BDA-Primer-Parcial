import pandas as pd
from sqlalchemy import create_engine
#install pymysql
# Conectar a la base de datos MySQL
usuario = 'root'
contraseña = 'root123'
host = 'localhost'
base_datos = 'Grupo_1_eventos_peligrosos'

# Crear la conexión a MySQL usando SQLAlchemy
engine = create_engine(f'mysql+pymysql://{usuario}:{contraseña}@{host}/{base_datos}')

# Ruta del archivo Excel
ruta_excel = 'SGR_EventosPeligrosos_2010_2022Diciembre.xlsx'

# Leer el archivo completo desde la hola Base20102023
df = pd.read_excel(ruta_excel, sheet_name="Base20102023")

# Llenar la tabla temporal en MySQL
df.to_sql(name='tmp_eventos_peligrosos', con=engine, if_exists='replace', index=False)

print("Importación completada.")