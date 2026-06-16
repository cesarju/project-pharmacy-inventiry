# Control de Inventario de Farmacia

Aplicación móvil desarrollada en **Flutter** para gestionar el stock de
medicamentos de un hospital. Funciona **sin conexión a internet**, **sin base
de datos** y **sin servicios externos**: toda la información se maneja en
memoria mientras la app está abierta.

Proyecto de nivel **intermedio** enfocado en diseño de interfaces, navegación
entre pantallas y lógica interna del manejo de datos.

---

## Funcionalidades

- **Registro de medicamentos** con nombre, categoría, laboratorio, stock y stock mínimo.
- **Dispensación (salida)** con descuento automático del stock.
- **Ingreso de stock** para reponer existencias.
- **Alertas visuales** cuando un medicamento llega a stock bajo o se agota.
- **Búsqueda** por nombre y **filtros** por estado (disponible / bajo / agotado) y por categoría.
- **Historial de movimientos** (dispensaciones e ingresos).
- **Resumen** con estadísticas: totales, unidades y existencias por categoría.

---

## Cómo ejecutar en VS Code

> Requiere Flutter 3.41+ y Dart 3.11+ (probado con tu versión 3.41.9).

Este paquete contiene el **código fuente** (`lib/`, `pubspec.yaml`, `test/`).
Para mantenerlo liviano **no incluye las carpetas de plataforma**
(`android/`, `ios/`, `web/`...), que se generan con un solo comando.

### Pasos

1. **Descomprime** el archivo `farmacia_inventario.zip`.

2. **Abre la carpeta** `farmacia_inventario` en VS Code
   (`Archivo > Abrir carpeta...`).

3. Abre una terminal en esa carpeta (`Terminal > Nueva terminal`) y genera
   las carpetas de plataforma:

   ```bash
   flutter create .
   ```

   Esto crea `android/`, `ios/`, `web/`, etc. **sin tocar** el código de `lib/`.

4. Descarga las dependencias:

   ```bash
   flutter pub get
   ```

5. **Ejecuta la app** (con un emulador abierto, un dispositivo conectado o en Chrome):

   ```bash
   flutter run
   ```

---

## Estructura del proyecto

```
lib/
├── main.dart                       Punto de entrada y tema
├── models/
│   ├── medicamento.dart            Modelo Medicamento + categorías
│   └── movimiento.dart             Modelo de movimientos
├── services/
│   └── inventario_store.dart       Lógica y datos EN MEMORIA (ChangeNotifier)
├── screens/
│   ├── home_screen.dart            Navegación con barra inferior
│   ├── inventario_screen.dart      Lista, búsqueda y filtros
│   ├── form_medicamento_screen.dart  Agregar / editar
│   ├── detalle_screen.dart         Detalle, dispensar, ingresar, eliminar
│   ├── movimientos_screen.dart     Historial de movimientos
│   └── resumen_screen.dart         Estadísticas
└── widgets/
    ├── medicamento_card.dart       Tarjeta de medicamento
    └── stock_badge.dart            Etiqueta de estado de stock
```

<img width="488" height="933" alt="image" src="https://github.com/user-attachments/assets/59755fdd-a74b-493f-8de8-79a8bfb75abb" />
<img width="488" height="933" alt="image" src="https://github.com/user-attachments/assets/7b897e8c-7524-4e7d-9f09-a630177b2e7d" />
<img width="488" height="933" alt="image" src="https://github.com/user-attachments/assets/3b969840-ad6b-4a5e-b6a5-1b9593ef17ea" />
<img width="488" height="933" alt="image" src="https://github.com/user-attachments/assets/524ab40e-ce74-4442-a01f-9d6a5aac1866" />



