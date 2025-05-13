# control_semestres

Esta aplicación se desarrollo con la intención de llevar el control de las materias que se lleva durante el semestre, siendo capaz de agregar, modificar y eliminar estos mismos.

Las herramientas utilizadas son:
- Dart (Lenguaje de programación)
- Flutter (Framework)
- SQLite (Base de datos)

---

## Versión actual
Este proyecto actualmente me ayuda a tener un registro de las materias y tener acceso rápido a información relevante.\
La tercera versión y la actual es la que más cambios conllevó, pues se agregó muchas pantallas y se hicieron modificaciones a como funciona los registros.\

Pero antes de empezar, la filosfía de los registros.\
Un semestre o cuatrimestre se definen como periodos "períodos academicos". Pueden haber varíos por años (En mi caso son tres cuatrimestres al año). Y cada uno posee sus propias materias.\

Diferentes períodos pueden tener "la misma materia". Pues, aunque tengan el mismo nombre, a nivel de base de datos estas se diferencian por el ID.

### Base de datos
Primero, la base de datos consta de más tablas y es más compleja.

![Diagrama entidad relación DB actual](./doc-media/V3-DB-Entidad-Relacion.jpeg)


---

## Primera versión
Este proyecto inició como un proyecto personal para poder tener un registro de las materias inscritas y las tareas realizadas durante el semestre. La primera versión se enfocó en establecer las principales pantallas y la clase para la manipulación de base de datos.

### Main

El archivo main establece el tema oscuro (En esta versión no se puede cambair el tema) y lleva a la pantalla principal.

![Código del archivo main](./doc-media/V1-main.png)

Esta versión consta de 3 pantallas, todas haciendo uso de un archivo que proporciona todos los métodos necesarios para el uso de la base datos. El archivo principal que lleva el nombre GradesScreen se encarga de mostrar las materias con las notas y profesor mediante una lista que también posee un encabezado y una línea final que muestra el promedio. Esta lista se forma con una función asíncrona donde se determina la respuesta de la base de datos para mostrar si está cargando, hubo un error, no hay datos o si construye la lista con los datos que recibió.

- Pantalla principal

  1. Pantalla principal sin datos


  ![Pantalla principal sin datos](./doc-media/V1-pantalla-principal.png)


  2. Pantalla principal con datos


  ![Pantalla principal con datos](./doc-media/V1-pantalla-principal-datos.png)


Las otras dos pantallas constan de los formularios para añadir un nuevo dato (accesible al presionar el botón abajo a la derecha) y para modificar/eliminar un dato (accesible al toque cualquiera de los datos listados en la pantalla principal). Estos dos poseen un código muy similar donde se tienen tres inputs, uno para la materia, otro para la nota y otra para el profesor, donde se evalúa si no se intenta agregar datos vacíos. Abajo se encuentran los botones de agregar y regresar o los botones de modificar, eliminar y regresar en el caso de encontrarse en la pantalla de modificación de datos.

- Pantalla agregar nota

    1. Pantalla para agregar datos


    ![Pantalla para agregar datos](./doc-media/V1-agregar-materia.png)


    2. Pantalla para agregar datos - en caso de poseer inputs vacíos


    ![Pantalla para agregar datos inputs vacíos](./doc-media/V1-agregar-materia-error.png)


La pantalla de modificar datos se accede al presionar alguna de las materias de la pantalla principal. Este te lleva a una pantalla identica a la de agregar datos, solo que mostrando los datos que ya se habían cargado en la base de datos mediante una consulta usando el ID del registro seleccionado.

- Pantalla editar nota


![Pantalla para modificar datos](./doc-media/V1-agregar-materia-dato.png)


### Basedato_helper
Este archivo tiene la clase que contiene los métodos para todas las operaciones que se realiza con la base de datos. En esta primera versión solo se usa una tabla, así que este archivo solo contiene las operaciones para iniciar la base de datos, insertar datos, eliminar datos, mostrar datos y calcular el promedio.
Cabe mencionar que, en este proyecto se usa una base de datos interna, así que es el propio dispositvo el que almacena esta y si se elimina la aplicación también se elimina la información en esta.

![Código Basedatohelper](./doc-media/V1-basedatohelper.png)

Como ya se mencionó, esta versión solo consta de una tabla

![Tabla notas estudiante](./doc-media/V1-DB.png)

Además, se realizó un diagrama de como se esperaba que creciera la base de datos al avanzar el proyecto.

![Planteamiento diagrama entidad relación](./doc-media/V1-ER-planteamiento.png)

---

## Segunda versión
En esta versión se enfocó en agregar la sección de tareas y hacer cambios en las pantallas establecidas para añadir información que resulta relevante.

### Tareas
Para empezar el cambio más importante: tareas\
Se modificó la base de datos para agregar las tablas de materias y tareas. Además, se agregó la sección de tareas en la pantalla principal, así que al acceder a esta se realiza una consulta para las materia y otra para las tareas.

![Pantalla principal con tarea](./doc-media/V2-pantalla-principal.jpg)

Las tareas son mostrados con un color dependiendo del estatus que poseen;
- Pendiente: Gris
- Finalizada: Verde
- Incompleta : Rojo

Estas tareas tienen su propio formulario para agregar nuevos, igual que los anteriores mostrados. Este se accede al presionar el boton "Añadir".

![Pantalla añadir tareas](./doc-media/V2-agregar-tarea.jpg)

Y al presionar una de las tareas te lleva la pantalla de modificar datos con los datos correspondiente al registro seleccionado.

### Cambios en pantallas materias
Al presionar una de las materias en la pantalla principal te dirige a una pantalla intermedia que muestra más datos de la materia

![Nueva pantalla datos materia](./doc-media/V2-materia-detalle.jpg)

Y ahora las materias cuentan con su propia tabla, donde el mayor cambio es que la nota se divide en 3 inputs (principalmente, porque así funciona mi universidad) y la nota mostrada en la pantalla principal es la suma de estas tres. A su vez, estos también significó cambios para las pantallas para agregar y modificar las materias.

![V2 agregar materia](./doc-media/V2-agregar-materia.jpg)