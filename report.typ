#import "lib/template.typ": conf
#import "lib/helpers.typ": *

#set text(lang: "es")

#show: doc => conf(
  title: [Sistema de Recomendación colaborativa sobre el dataset movielens],
  abstract: [
    Este trabajo presenta el diseño e implementación de un sistema de recomendación colaborativa utilizando el dataset MovieLens, con el objetivo de predecir las preferencias de los usuarios y mejorar la personalización en la selección de películas. Se comparan enfoques de *filtrado colaborativo basado en memoria* (vecindarios usuario-usuario y ítem-ítem con similitudes cosine y Pearson) y modelos basados en factores latentes mediante descomposición matricial (SVD/SVD++). El estudio aborda el *preprocesamiento de datos* (filtrado de usuarios/ítems esparsos, normalización de calificaciones y particionado temporal) y evalúa el desempeño con *métricas de error* y de *ranking*, además de un análisis de cobertura y diversidad.
  ],
  affiliations: (
    (
      id: 1,
      name: "Universidad de La Laguna",
      full: [
        Sistemas Inteligentes, Escuela Superior de Ingeniería y Tecnología,
        #linebreak()Universidad de La Laguna, Canarias, España
      ],
    ),
  ),
  authors: (
    (
      name: "Pablo Hernández Jiménez",
      affiliation: [1],
      email: "alu0101495934@ull.edu.es",
      equal-contributor: true,
    ),
    (
      name: "Eric Ríos Hamilton",
      affiliation: [1],
      email: "alu0101549835@ull.edu.es",
      equal-contributor: true,
    ),
    (
      name: "Enmanuel Vegas Acosta",
      affiliation: [1],
      email: "alu0101281698@ull.edu.es",
      equal-contributor: true,
    ),
  ),
  // date: datetime.today(),
  accent: rgb("#5c068c"),
  doc,
)

= Sistemas de recomendación

Los sistemas de recomendación son herramientas que ayudan a las personas
a encontrar contenido relevante dentro de un conjunto enorme de opciones
#footnote[
  Una introducción general puede encontrarse en
  #link("https://en.wikipedia.org/wiki/Recommender_system")[
    Recommender system (Wikipedia, en inglés)
  ].
].
En los sistemas actuales, esta tarea se apoya de forma intensiva en
métodos de inteligencia artificial
#footnote[
  #link("https://en.wikipedia.org/wiki/Artificial_intelligence")[
    Artificial intelligence (Wikipedia, en inglés)
  ].
]
y de aprendizaje automático
#footnote[
  #link("https://en.wikipedia.org/wiki/Machine_learning")[
    Machine learning (Wikipedia, en inglés)
  ].
],
que permiten aprender del comportamiento de los usuarios, detectar
patrones en sus interacciones y ofrecer recomendaciones cada vez más
precisas.

De forma muy simplificada, pueden distinguirse dos grandes enfoques:

- *Métodos colaborativos*
- *Métodos basados en contenido*

== Métodos colaborativos

*Los sistemas de filtrado colaborativo* se basan en las valoraciones y
acciones de las personas usuarias
#footnote[
  Véase
  #link("https://en.wikipedia.org/wiki/Collaborative_filtering")[
    Collaborative filtering (Wikipedia, en inglés)
  ].
].
La idea es sencilla: si dos usuarios han mostrado interés por elementos
similares en el pasado, es probable que compartan gustos también en el
futuro. El sistema compara las valoraciones de un usuario con las de
otros usuarios y, a partir de esas similitudes, recomienda elementos que
aún no ha visto, pero que han gustado a personas con preferencias
parecidas.

== Métodos basados en contenido

Por su parte, *los sistemas basados en contenido* se fijan en las
características de los propios ítems que se quieren recomendar
#footnote[
  Una descripción accesible puede encontrarse en
  #link("https://www.ibm.com/think/topics/content-based-filtering")[
    Content-based filtering (IBM, en inglés)
  ].
].
En el caso de una película, por ejemplo, el sistema puede considerar el
género, la duración, el director, el reparto o el país de producción.

Con esta información construye un *perfil de usuario* que resume qué
tipos de contenido le gustan. Para ello analiza qué elementos ha
valorado positivamente o con cuáles ha interactuado más. Después,
recomienda nuevos contenidos que comparten rasgos importantes con
aquellos que ya han resultado de su agrado.

== Enfoques híbridos

En la práctica, la mayoría de los sistemas de recomendación actuales son
*enfoques híbridos* que combinan métodos colaborativos y basados en
contenido
#footnote[
  Introducción general a sistemas híbridos en
  #link("https://en.wikipedia.org/wiki/Recommender_system#Hybrid_recommender_systems")[
    Hybrid recommender systems (Wikipedia, en inglés)
  ].
].
Al integrar las fortalezas de ambos enfoques, estos sistemas:

- ofrecen recomendaciones más robustas,
- reducen las limitaciones de cada método por separado y
- proporcionan una experiencia más satisfactoria y personalizada para
  las personas usuarias.

== Deep learning en sistemas de recomendación

En los últimos años, el uso de *deep learning* ha transformado en gran
medida el diseño de sistemas de recomendación
#footnote[
  Una visión general se presenta en
  #link("https://en.wikipedia.org/wiki/Deep_learning")[
    Deep learning (Wikipedia, en inglés)
  ].
].
Las redes neuronales profundas permiten trabajar con grandes volúmenes
de datos y capturar patrones complejos que resultan difíciles de
modelar con técnicas más tradicionales.

En este contexto, el deep learning se utiliza de varias formas:

- Para aprender representaciones (o *embeddings*) de usuarios e ítems
  que resumen sus características en vectores numéricos de baja
  dimensión.
- Para combinar información muy diversa: valoraciones explícitas,
  historial de clics, texto (por ejemplo, descripciones o reseñas),
  imágenes o incluso audio y vídeo.
- Para modelar la evolución temporal de las preferencias de los usuarios
  y adaptarse mejor a cambios en sus intereses.

Un ejemplo habitual es el uso de redes neuronales para extender el
filtrado colaborativo clásico: en lugar de trabajar solo con una matriz
de valoraciones, el modelo neuronal aprende representaciones latentes
más ricas a partir de múltiples fuentes de información. Esto permite
mejorar la calidad de las recomendaciones, especialmente en escenarios
con muchos ítems, datos ruidosos o preferencias cambiantes.

Aunque estos modelos suelen ser más costosos de entrenar y de explicar,
han demostrado ser especialmente eficaces en entornos de gran escala,
como plataformas de vídeo, música o comercio electrónico, donde incluso
pequeñas mejoras en la precisión de las recomendaciones tienen un
impacto significativo en la experiencia de las personas usuarias.

= Entorno de desarrollo

La parte de codificación de este proyecto se organizará en torno a la
herramienta `uv`
#footnote[
  Información general en
  #link("https://github.com/astral-sh/uv")[uv (GitHub)].
],
que se empleará tanto para la gestión de dependencias como para la
creación y el aislamiento de los distintos entornos de ejecución. Esto
permitirá definir de forma reproducible las librerías necesarias en cada
fase del proyecto (prototipado, ETL, modelado y backend) y simplificar
la instalación y actualización del entorno en distintas máquinas de
trabajo.

El desarrollo se llevará a cabo utilizando Visual Studio Code
#footnote[
  #link("https://code.visualstudio.com/")[Visual Studio Code].
]
como entorno principal de edición y depuración. Además, se hará uso de
librerías del ecosistema científico de Python para la carga, limpieza,
exploración y transformación del conjunto de datos, así como para la
construcción y evaluación de los modelos necesarios para alcanzar el
objetivo final del trabajo.

En una primera fase, la aplicación se implementará y ejecutará en un
entorno de línea de comandos. Las distintas funcionalidades se
prototiparán y validarán previamente en notebooks de *marimo*
#footnote[
  #link("https://marimo.io/")[marimo: reactive Python notebooks].
],
lo que permitirá iterar de manera rápida sobre las ideas, realizar
pruebas controladas y documentar de forma más clara el flujo de trabajo
y los resultados intermedios.

== Orquestación de la ETL y del entrenamiento con Dagster

Para gestionar de forma estructurada los procesos de extracción,
transformación y carga de datos (ETL), así como las tareas de
entrenamiento y reentrenamiento de los modelos, se empleará *Dagster*
#footnote[
  #link("https://dagster.io/")[Dagster: data orchestrator].
]
como herramienta de orquestación. Mediante la definición de *jobs* y
*ops* (o *assets*), Dagster permitirá describir de manera declarativa el
flujo completo de trabajo: desde la ingesta de los datos brutos hasta la
generación de modelos listos para ser consumidos por la aplicación.

El uso de Dagster aporta varias ventajas:

- facilita la separación clara entre las distintas etapas de la ETL y
  del ciclo de vida del modelo,
- permite monitorizar la ejecución de cada paso (por ejemplo, la calidad
  de los datos, la duración de las tareas o posibles errores), y
- hace posible reejecutar solo aquellas partes del flujo que lo
  necesiten cuando cambien los datos o la configuración.

De este modo, la canalización de datos y el proceso de entrenamiento se
integran en un sistema reproducible, trazable y más sencillo de
mantener a medida que el proyecto crece.

== Desarrollo del backend

Una vez que la implementación alcance un grado suficiente de estabilidad
y madurez, se procederá a desarrollar un backend que exponga la lógica
de negocio a través de una API. Para ello se utilizará principalmente
FastAPI
#footnote[
  #link("https://fastapi.tiangolo.com/")[FastAPI framework].
],
por su buen rendimiento, su sintaxis declarativa y su buena integración
con herramientas de validación de datos y documentación automática. La
validación y el tipado de los datos de entrada y salida se gestionarán
con Pydantic
#footnote[
  #link("https://docs.pydantic.dev/")[Pydantic].
],
lo que permitirá definir modelos de datos claros, consistentes y
fácilmente reutilizables dentro de la aplicación.

Este enfoque incremental —desde prototipos en notebooks y ejecución por
línea de comandos, pasando por la orquestación con Dagster, hasta un
backend estructurado gestionado con `uv`— facilita la detección temprana
de errores, mejora la trazabilidad de las decisiones técnicas y sienta
una base sólida para futuras ampliaciones o integraciones del sistema.

== Uso de IA

En este proyecto se permitirá la utilización de herramientas de IA generativa como Copilot, que está incluido en el editor de texto escogido. Sin embargo, este uso estará limitado mayoritariamente a la consulta de dudas puntuales y otras funciones de autocompletado, de tal manera que se favorezca el aprendizaje de las técnicas aplicadas en la asignatura.

= Uso de la librería Surprise

Antes de construir el sistema de recomendación colaborativo con la
librería *Surprise*
#footnote[
  Official documentation:
  #link("https://surprise.readthedocs.io/en/stable/")[
    scikit-surprise (Surprise)
  ].
],
se realizará un preprocesado del conjunto de datos MovieLens
#footnote[
  Classical recommendation dataset:
  #link("https://grouplens.org/datasets/movielens/")[
    MovieLens
  ].
].
Este preprocesado incluirá, entre otras tareas, la limpieza de registros
incompletos, el filtrado de usuarios o ítems con muy pocas
interacciones y la transformación de los datos al formato requerido por
Surprise para su posterior uso en los algoritmos de predicción.

Surprise ofrece una caja de herramientas focalizada en la construcción y
mejora de sistemas recomendadores colaborativos. En concreto, proporciona
un control detallado sobre los datos, una gama amplia de algoritmos y
métricas para calificar y evaluar los resultados, garantizando así un
marco de trabajo óptimo y confiable para este tipo de sistemas.

En este proyecto emplearemos los recursos que ofrece Surprise para
realizar el módulo recomendador colaborativo.

== Algoritmos de Surprise <algoritmos>

Estos son los algoritmos implementados en Surprise, descritos en @surprise_prediction_algorithms.

En las fórmulas, $r_(u i)$ denota la valoración real del usuario $u$
sobre el ítem $i$, y $hat(r)_(u i)$ la predicción del modelo.

=== `random_pred.NormalPredictor`

`NormalPredictor` predice una valoración basándose en la distribución del
conjunto de entrenamiento, asumiendo que esta es normal. Se estima una
media $mu$ y una desviación típica $sigma$ y se modela:

\
#math.equation(
  block: true,
  $ r_(u i) ~ N(mu, sigma^2) $,
)
\
Cada valoración se genera muestreando de manera independiente de esta
distribución.

=== `baseline_only.BaselineOnly`

`BaselineOnly` predice la estimación de referencia (*baseline*) para un
usuario y un ítem dados mediante:

\
#math.equation(
  block: true,
  $ hat(r)_(u i) = mu + b_u + b_i $,
)
\
donde:

- $mu$ es la media global de todas las valoraciones,
- $b_u$ es el sesgo del usuario $u$,
- $b_i$ es el sesgo del ítem $i$.

Si el usuario $u$ o el ítem $i$ son desconocidos, sus sesgos se toman
como cero.

=== `knns.KNNBasic`

`KNNBasic` es la versión básica de *k-Nearest Neighbours*. Permite
calcular similitud entre usuarios o entre ítems según el parámetro
`user_based` de `sim_options`. La predicción típica puede escribirse
como:

\
#math.equation(
  block: true,
  $
    hat(r)_(u i) =
    frac(
      sum_(v in N_k(u, i)) s(u, v) * r_(v i),
      sum_(v in N_k(u, i)) abs(s(u, v))
    )
  $,
)
\
donde:

- $N_k(u, i)$ es el conjunto de los $k$ vecinos más similares que han
  valorado el ítem $i$,
- $s(u, v)$ es la similitud entre usuarios (o ítems, según el modo),
- $r_(v i)$ es la valoración del vecino $v$ sobre el ítem $i$.

Parámetros relevantes:

- `k` (int): número máximo de vecinos a tener en cuenta,
- `min_k` (int): número mínimo de vecinos,
- `sim_options` (dict): opciones para la medida de similitud,
- `verbose` (bool): si se debe imprimir una traza.

=== `knns.KNNWithMeans`

`KNNWithMeans` es igual que KNN normal, pero teniendo en cuenta las
valoraciones medias de cada usuario. La fórmula se puede expresar como:

\
#math.equation(
  block: true,
  $
    hat(r)_(u i) =
    bar(r)_u +
    frac(
      sum_(v in N_k(u, i)) s(u, v) * (r_(v i) - bar(r)_v),
      sum_(v in N_k(u, i)) abs(s(u, v))
    )
  $,
)
\
donde $bar(r)_u$ y $bar(r)_v$ son las medias de valoración de los
usuarios $u$ y $v$.

=== `knns.KNNWithZScore`

`KNNWithZScore` es igual que KNN normal, pero teniendo en cuenta la
*z-score* de cada usuario. Sea $mu_u$ la media del usuario $u$ y
$sigma_u$ su desviación estándar. Entonces:

\
#math.equation(
  block: true,
  $
    hat(r)_(u i) =
    mu_u +
    sigma_u *
    frac(
      sum_(v in N_k(u, i))
      s(u, v) * ((r_(v i) - mu_v) / sigma_v),
      sum_(v in N_k(u, i)) abs(s(u, v))
    )
  $,
)
\

Esto normaliza las valoraciones de cada usuario antes de combinarlas.

=== `knns.KNNBaseline`

`KNNBaseline` es igual que KNN normal, pero teniendo en cuenta la
estimación de referencia (*baseline*) como en `BaselineOnly`. La
predicción puede escribirse como:

\
#math.equation(
  block: true,
  $
    hat(r)_(u i) =
    b_(u i) +
    frac(
      sum_(v in N_k(u, i)) s(u, v) * (r_(v i) - b_(v i)),
      sum_(v in N_k(u, i)) abs(s(u, v))
    )
  $,
)
\
donde:

- $b_(u i) = mu + b_u + b_i$,
- $b_(v i) = mu + b_v + b_i$.

=== `matrix_factorization.SVD`

`SVD` calcula la predicción con:

\
#math.equation(
  block: true,
  $
    hat(r)_(u i) =
    mu + b_u + b_i + q_i^T * p_u
  $,
)
\
donde:

- $mu$ es la media global,
- $b_u$ y $b_i$ son sesgos de usuario e ítem respectivamente,
- $p_u$ es el vector de factores latentes del usuario $u$,
- $q_i$ es el vector de factores latentes del ítem $i$.

Si el usuario o el ítem son nulos, sus sesgos y factores se consideran
nulos. Los parámetros se ajustan minimizando un error cuadrático medio
regularizado sobre el conjunto de entrenamiento.

=== `matrix_factorization.SVDpp`

`SVDpp` es una extensión de SVD que incorpora la información de
valoraciones implícitas (por ejemplo, que un usuario haya valorado un
ítem, independientemente del valor). La fórmula habitual es:

\
#math.equation(
  block: true,
  $
    hat(r)_(u i) =
    mu + b_u + b_i +
    q_i^T *
    (
      p_u +
      frac(
        1,
        sqrt(|N(u)|)
      ) *
      sum_(j in N(u)) y_j
    )
  $,
)
\
donde:

- $N(u)$ es el conjunto de ítems que el usuario $u$ ha valorado
  implícitamente,
- $y_j$ son factores implícitos asociados a cada ítem $j$.

Si el usuario o el ítem es desconocido, sus sesgos y factores implícitos
se consideran cero.

=== `matrix_factorization.NMF`

`NMF` es similar a SVD, pero basado en *Non-negative Matrix
Factorization*. En la versión base, sin sesgos, la fórmula de predicción
es:

\
#math.equation(
  block: true,
  $ hat(r)_(u i) = q_i^T * p_u $,
)
\
sujeta a la restricción de no negatividad:
\
#math.equation(
  block: true,
  $ p_u >= 0, quad q_i >= 0 $,
)
\
También existe una versión que incorpora sesgos de forma análoga a SVD.

=== `slope_one.SlopeOne`

`SlopeOne` es un algoritmo sencillo basado en diferencias promedio entre
ítems. Una formulación típica es:

\
#math.equation(
  block: true,
  $
    hat(r)_(u i) =
    frac(
      sum_(j in R_i(u)) (r_(u j) + "dev"_(i j)),
      |R_i(u)|
    )
  $,
)
\
donde:

- $R_i(u)$ es el conjunto de ítems $j$ valorados por el usuario $u$ y
  que se usan para estimar el ítem $i$,
- $"dev"_(i j)$ es la diferencia promedio entre los ítems $i$ y $j$:

\
#math.equation(
  block: true,
  $
    "dev"_(i j) =
    frac(
      sum_(u in U_(i j)) (r_(u i) - r_(u j)),
      |U_(i j)|
    )
  $,
)
\

y $U_(i j)$ es el conjunto de usuarios que han valorado tanto $i$ como
$j$.

=== `co_clustering.CoClustering`

`CoClustering` es un algoritmo basado en el *co-clustering* de usuarios e
ítems. Los usuarios se agrupan en $n_"cltr"_u$ clústeres y los ítems en
$n_"cltr"_i$, formando co-clusters. Una forma habitual de escribir la
predicción es:


\
#math.equation(
  block: true,
  $
    hat(r)_(u i) =
    bar(C)_(c(u), c(i)) +
    (mu_u - bar(C)_(c(u), .)) +
    (mu_i - bar(C)_(., c(i)))
  $,
)
\
donde:

- $c(u)$ es el clúster del usuario $u$,
- $c(i)$ es el clúster del ítem $i$,
- $bar(C)_(c(u), c(i))$ es la media del co-cluster correspondiente,
- $mu_u$ es la media de las valoraciones del usuario $u$,
- $mu_i$ es la media de las valoraciones del ítem $i$.

Si el usuario es desconocido, la predicción se reduce a $mu_i$; si el
ítem es desconocido, a $mu_u$; y si ambos lo son, a la media global
$mu$.

== Métricas de Surprise <metricas>

La librería Surprise también proporciona herramientas para evaluar la
calidad de las predicciones. En el módulo `accuracy` se implementan
métodos para computar métricas de exactitud dado un conjunto de
predicciones.

Sea $r_i$ la valoración real y $hat(r)_i$ la predicción para cada
observación $i = 1, ..., n$.

=== Mean Squared Error (MSE)

El *Mean Squared Error* (MSE) se define como:

\
#math.equation(
  block: true,
  numbering: "(1)",
  $
    "MSE" =
    frac(
      1,
      n
    ) *
    sum_(i = 1)^n (r_i - hat(r)_i)^2
  $,
)
\
Penaliza más los errores grandes que los pequeños debido al cuadrado.
Cuanto menor sea el MSE, más precisa es la predicción.

=== Root Mean Squared Error (RMSE)

El *Root Mean Squared Error* (RMSE) es la raíz cuadrada del MSE:
\
#math.equation(
  block: true,
  numbering: "(1)",
  $
    "RMSE" =
    sqrt(
      frac(
        1,
        n
      ) *
      sum_(i = 1)^n (r_i - hat(r)_i)^2
    )
  $,
)
\
Es la métrica más común en sistemas de recomendación. La raíz permite
expresar el error en la misma escala que las valoraciones (por ejemplo,
1-5 estrellas).

=== Mean Absolute Error (MAE)

El *Mean Absolute Error* (MAE) mide el promedio de las diferencias
absolutas:

\
#math.equation(
  block: true,
  numbering: "(1)",
  $
    "MAE" =
    frac(
      1,
      n
    ) *
    sum_(i = 1)^n abs(r_i - hat(r)_i)
  $,
)
\
Es más robusto frente a *outliers* que el MSE, ya que no penaliza tanto
los errores grandes. Cuanto menor sea el MAE, más exacto es el modelo.

=== Fraction of Concordant Pairs (FCP)

La *Fraction of Concordant Pairs* (FCP) mide la capacidad del sistema
para ordenar correctamente los ítems según las preferencias del usuario.
Se consideran pares $(i, j)$ tales que un usuario ha puntuado
$r_i > r_j$ y se verifica si el modelo también predice
$hat(r)_i > hat(r)_j$.

Sea $C$ el número de pares concordantes y $T$ el número total de pares
comparables. Entonces:

\
#math.equation(
  block: true,
  numbering: "(1)",
  $ "FCP" = C / T $,
)
\
Un valor de FCP cercano a 1 indica que el modelo respeta bien el orden
de las preferencias.

== Criterio de selección

En base a los resultados arrojados por las métricas, se seleccionará el
único modelo o combinación de modelos que proporcione el mejor
resultado, utilizando distintos criterios y algoritmos para dicha
selección.

En primer lugar, para cada algoritmo considerado de Surprise se
efectuará una validación cruzada *k-fold* estratificada por usuario,
utilizando como métrica principal el RMSE por su interpretabilidad en la
escala de las valoraciones y su uso extendido en la literatura.

De forma complementaria, se monitorizarán MAE y MSE para detectar
sensibilidad a *outliers* y errores grandes, así como FCP para valorar
la capacidad de ordenar correctamente las preferencias.

Además, se evaluarán métricas de *ranking* sobre listas Top-$N$ por
usuario, concretamente NDCG\@k (por ejemplo, $k in {5, 10}$) para
capturar la calidad del orden ponderado por posición, MRR (*Mean
Reciprocal Rank*) y RecipRank (*Reciprocal Rank* por usuario), con el
fin de medir la posición del primer acierto.

La sintonía de hiperparámetros se llevará a cabo con `GridSearchCV`
sobre el conjunto de entrenamiento, optimizando RMSE y reportando la
desviación estándar por pliegue para estimar la estabilidad. Cuando el
objetivo sea principalmente de *ranking*, se contrastarán también las
configuraciones finalistas en términos de NDCG\@k y MRR.

De esta manera, el criterio de selección priorizará el modelo con menor
RMSE medio en validación y variabilidad reducida; en caso de resultados
próximos, se emplearán criterios de desempate atendiendo a:

- mayor NDCG\@k y MRR, junto a FCP elevada y MAE comparable o inferior;
- coste computacional (tiempo de entrenamiento e inferencia) y
  escalabilidad;
- robustez ante la dispersión de los datos (cobertura de predicciones) y
  comportamiento en escenarios de *cold start*.

Cuando dos modelos muestren comportamientos complementarios, se
considerará un ensamblado sencillo mediante promedio ponderado de
puntuaciones normalizadas, adoptándolo únicamente si aporta una mejora
estadísticamente significativa en RMSE y en las métricas de *ranking*
(NDCG\@k, MRR / RecipRank) sin comprometer la latencia.

La decisión final se validará en un conjunto de pruebas mantenido al
margen del ajuste, aplicando el mismo procedimiento Top-$N$ y
documentando los hiperparámetros definitivos, la semilla aleatoria y
todas las métricas reportadas.

= Dataset

En este proyecto se utilizará el conjunto de datos *“MovieLens”* para construir el sistema de recomendación colaborativo. Este conjunto de datos proporciona información y datos relevantes (título, año, género, etc.) de películas, además de una gran cantidad de valoraciones de usuarios, basado en un sistema de calificación de 5 estrellas. Estos elementos hacen que estos Datasets sean un ejemplar idóneo para construir nuestro sistema de recomendación.

MovieLens provee distintos Datasets que son actualizados periódicamente. El tamaño, cantidad de valoraciones y rango de años tomados en cada uno varía en función de las necesidades o finalidades que quieran ser satisfechas.

== Estructura de los datos

El conjunto de datos se estructura en cuatro ficheros CSV distintos:

#v(0.5em)

// Tabla para organizar los ficheros y sus columnas
#table(
  columns: (auto, 1fr),
  inset: 10pt,
  align: (col, row) => (if col == 0 { right + horizon } else { left }),
  stroke: (x, y) => (
    bottom: if y == 0 { 1pt } else { 0.5pt + gray },
    top: if y == 0 { 1pt } else { 0pt },
  ),

  // Cabeceras
  [*Fichero*], [*Contenido y Columnas*],

  // Fila 1: Ratings
  [`ratings.csv`],
  [
    Cada fila representa una valoración de una película realizada por un usuario.\
    #text(size: 0.9em, fill: luma(100))[`userId`, `movieId`, `rating`, `timestamp`]
  ],

  // Fila 2: Tags
  [`tags.csv`],
  [
    Cada fila representa una etiqueta asignada por un usuario a una película.\
    #text(size: 0.9em, fill: luma(100))[`userId`, `movieId`, `tag`, `timestamp`]
  ],

  // Fila 3: Movies
  [`movies.csv`],
  [
    Cada fila representa una película.\
    #text(size: 0.9em, fill: luma(100))[`movieId`, `title`, `genres`]
  ],

  // Fila 4: Links
  [`links.csv`],
  [
    Cada fila provee enlaces a otras fuentes de datos sobre las películas.\
    #text(size: 0.9em, fill: luma(100))[`movieId`, `imdbId`, `tmdbId`]
  ],
)

=== Definición de variables

Contamos con las siguientes columnas:

#set terms(separator: [: ], indent: 1em, tight: true)

#let defitem(name, desc) = [/ #strong(name): #desc]

\
#defitem([`userId`], [Identificador único de usuario.])
#defitem([`movieId`], [Identificador único de película.])
#defitem([`rating`], [Valoración en escala de cinco estrellas con incrementos de media estrella.])
#defitem([`timestamp`], [Segundos pasados desde la medianoche UTC del 1 de enero de 1970.])
#defitem([`tag`], [Metadatos generados por usuarios. Una sola palabra o frase simple.])
#defitem([`title`], [Título de película.])
#defitem([`imdbId`], [Identificador de película utilizado por imdb.com.])
#defitem([`tmdbId`], [Identificador de película utilizado por themoviedb.org.])

/ #strong(`genres`): Géneros de la película, separados por el carácter `|`.

#linebreak()
En las gráficas a continuación se puede observar las diferencias entre los dos datasets *MovieLens*.
// Incluye exclusivamente:

// #columns(4, gutter: 1em)[
//   - Action
//   - Adventure
//   - Animation
//   - Children's
//   - Comedy
//   - Crime
//   - Documentary
//   - Drama
//   - Fantasy
//   - Film-Noir
//   - Horror
//   - Musical
//   - Mystery
//   - Romance
//   - Sci-Fi
//   - Thriller
//   - War
//   - Western
//   - (no genres listed)
// ]

#v(1em)


#grid(
  align: bottom,
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    caption: "Genre Dominance Per Dataset",
    image("data/chart_heatmap.svg"),
  ),
  figure(
    caption: "Size Per Dataset",
    image("data/chart_stats.svg"),
  ),
)

#figure(
  caption: "Release Year Distribution",
  image("data/chart_ridgeline.svg", width: 70%),
)



= Evaluación del sistema de recomendación

Para iniciar con la creación del sistema de recomendación, partiremos de los dataset *MovieLens 100K* y *MovieLens 32M*. Estos conjuntos de datos serán tratados con los #link(<algoritmos>)[Algoritmos de Surprise Explicados]. Por otra parte, la calidad de los resultados obtenidos será verificada a través de las #link(<metricas>)[métricas propuestas anteriormente].

#let raw-100k = csv("data/100k.csv")
#let raw-32m = csv("data/32m.csv")

#page(flipped: true)[

  == Comparación de algoritmos

  #show table.cell.where(y: 1): set text(weight: "bold")
  #show table.cell.where(x: 0): set text(weight: "bold")

  #comparison-table(
    csv-100k: raw-100k,
    csv-32m: raw-32m,
    caption: "Comparativa de algoritmos en el dataset MovieLens (100K / 32M)",
    algorithms: (
      "Normal Predictor",
      "Baseline Only",
      "KNN Basic",
      "SVD",
      "SVD++",
      "SlopeOne",
      "CoClustering",
    ),
  )
  #block(
    fill: luma(240),
    inset: 10pt,
    radius: 4pt,
    width: 100%,
    [
      *Nota:* Están marcados en #strong(text(fill: red)[rojo]) los mejores resultados en cada métrica para cada dataset.
    ],
  )
]

=== Análisis de Ejecuciones y Conclusiones

Las conclusiones que se pueden extraer de las ejecuciones anteriores son bastante interesantes:

// Lista para los puntos principales del análisis
#list(marker: [--], indent: 0em)[
  // Punto 1: Baselines
  *El Normal Predictor y Baseline Only* ofrecen resultados razonables en ambos datasets, pero sus errores (MAE y RMSE) son notablemente más altos que los de técnicas colaborativas más avanzadas.
][
  // Punto 2: KNN
  El primer caso de mejora lo notamos en el *rendimiento sólido de los modelos KNN* (Basic, with Means, with Z-Score y Baseline) en el dataset 100K, con errores en torno a $"MAE" approx 0.69-0.76$ y $"RMSE" approx 0.90-0.97$.

  #h(1em) _Nota:_ Con el dataset 32M ningún KNN pudo ejecutarse, probablemente debido al coste en memoria, ya que estos algoritmos requieren almacenar y procesar la matriz completa de similitudes, resultando poco escalables.
][
  // Punto 3: Factorización de Matrices
  Con respecto a los *métodos de factorización de matrices*:
  - *SVD* ofrece uno de los mejores rendimientos en 100K, alcanzando $"MAE "approx 0.67$ y $"RMSE" approx 0.87$, con un tiempo de ejecución moderado ($approx 7s$).
  - *SVD++* mejora ligeramente el error para 100K, pero su tiempo es muchísimo mayor ($approx 295s$).
  - *NMF* también muestra buenos errores en 100K ($approx 0.70$ MAE), que son mejorados al utilizar el dataset 32M, hasta los $approx 0.65$ MAE.

  // Punto destacado
  #block(
    fill: luma(240),
    inset: 10pt,
    radius: 4pt,
    width: 100%,
    [
      *Destacado:* Los mejores resultados de toda la comparativa se obtienen con el algoritmo *SVD* con el dataset de 32M, reduciéndose hasta $"MAE" approx 0.61$ y $"RMSE" approx 0.81$.
    ],
  )
][
  // Punto 4: Algoritmos especializados
  Si nos enfocamos en los *algoritmos más especializados*:
  - *SlopeOne* obtuvo resultados decentes en 100K ($"MAE" approx 0.69, "RMSE" approx 0.90$), aunque no pudo completarse para 32M por limitaciones de hardware.
  - *CoClustering* sí se ejecutó en ambos datasets, con mejor rendimiento en 32M ($"MAE" approx 0.73, "RMSE" approx 0.84$) con respecto al dataset más pequeño.
]

// Conclusiones finales separadas visualmente
=== Resumen Final

Podemos concluir que: #linebreak()#linebreak()

1. Para *datasets pequeños (100K)*, todos los algoritmos funcionan adecuadamente y permiten observar sus diferencias de precisión, siendo los mejores el SVD y el SVD++.

2. Para *datasets grandes (32M)* algunos algoritmos, especialmente los métodos basados en vecinos (KNN), no pueden ejecutarse por el alto coste en memoria.

#line(length: 100%, stroke: 0.5pt + gray)

#pad(x: 1em)[
  Los modelos basados en factorización (específicamente *SVD y NMF*) y *CoClustering* ofrecen la mejor relación entre precisión y escalabilidad.

  *SVD destaca como el mejor balance entre rendimiento y coste computacional.* SVD++, aunque más preciso, es más costoso computacionalmente.
]

#pagebreak()

= Propuesta del módulo recomendador colaborativo

Los dos modelos con mejores resultados han sido *Baseline* y *SVD*. Para el módulo final se ha optado por un acercamiento híbrido. Se ha realizado experimentación probando distintas ponderaciones para cada modelo sobre el dataset de *100K*. Una vez obtenidos los resultados, se ha aplicado la mejor combinación al dataset *32M*.

= Construcción del perfil de usuario

Para agilizar la construcción del perfil de usuario se recurrirá a la gamificación del proceso. Tomando inspiración de
The Higher Lower Game #footnote[
  #link("https://www.higherlowergame.com/")[The Higher Lower Game].
], se le presentarán al usuario distintas películas representativas (basándose en el ranking global). A medida que se vaya formando el perfil, se utilizará el recomendador subyacente para proponer más películas a valorar. Se propondrán películas de distintos cuartiles para evitar sesgos durante la creación. Con esto se irá refinando el perfil del usuario hasta obtener uno satisfactorio. En ese momento ya se podrán realizar las recomendaciones definitivas.

No se pedirá al usuario que cree una cuenta, los datos del perfil se guardarán localmente en el navegador.

El usuario podrá utilizar la aplicación como recomendador de películas. Asimismo se brindará información sobre el perfil generado, permitiendo conocer distintos datos sobre las preferencias a un nivel cuantitativo.

#page[
  #bibliography(title: "Bibliografia", "bibliography.bib")
]
