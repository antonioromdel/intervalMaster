# FitChrono ⏱️

**FitChrono** es una aplicación de cronometraje de ejercicios desarrollada en **Flutter**, diseñada para crear entrenamientos intermitentes personalizados con ciclos, rondas y tiempos completamente configurables. Su enfoque principal es proporcionar una **interfaz clara, intuitiva y fácil de usar** para maximizar la eficiencia de tus entrenamientos.

## 📋 Características

- ⚙️ **Configuración personalizada** de tiempo de preparación, ejercicio y descanso
- 🔄 **Definición de ciclos** (ejercicio + descanso) y **rondas** (intervalos completos)
- 📝 **Creación de rutinas** con distintos ejercicios y tiempos específicos
- 🎨 **Interfaz moderna y clara** que facilita el seguimiento del entrenamiento en tiempo real
- 🔔 **Notificaciones opcionales** para avisar cambios de fase durante el entrenamiento
- 📱 **Diseño responsivo** adaptado a diferentes tamaños de pantalla

## 🚀 Instalación

### Prerrequisitos

- Flutter SDK (versión 3.0 o superior)
- Dart SDK
- Android Studio / Xcode (para desarrollo móvil)
- Un editor de código (VS Code, Android Studio, etc.)

### Pasos de instalación

1. **Clona el repositorio**
   ```bash
   git clone https://github.com/tu-usuario/fitchrono.git
   cd fitchrono
   ```

2. **Instala las dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecuta la aplicación**
   ```bash
   flutter run
   ```

## 📦 Dependencias principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  # Añade aquí tus dependencias específicas
  # flutter_local_notifications: ^x.x.x (si usas notificaciones)
```

## 🎯 Uso

1. **Crear un entrenamiento**
    - Abre la aplicación
    - Configura el tiempo de preparación
    - Define el tiempo de ejercicio y descanso
    - Establece el número de ciclos y rondas

2. **Iniciar el cronómetro**
    - Presiona el botón de inicio
    - Sigue las indicaciones visuales en pantalla
    - Recibe notificaciones al cambiar de fase

3. **Pausar o detener**
    - Usa los controles para pausar o detener el entrenamiento
    - Guarda o descarta tu progreso

## 📱 Capturas de pantalla

_Añade aquí capturas de pantalla de tu aplicación_

## 🛠️ Tecnologías utilizadas

- **Flutter** - Framework de desarrollo
- **Dart** - Lenguaje de programación
- **Material Design** - Sistema de diseño
- **Flutter Local Notifications** (opcional) - Para notificaciones

## 📂 Estructura del proyecto

```
lib/
├── main.dart              # Punto de entrada de la aplicación
├── screens/               # Pantallas de la aplicación
├── widgets/               # Widgets reutilizables
├── models/                # Modelos de datos
├── services/              # Servicios (notificaciones, storage, etc.)
└── utils/                 # Utilidades y constantes
```

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Para cambios importantes:

1. Haz fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/NuevaCaracteristica`)
3. Commit tus cambios (`git commit -m 'Añade nueva característica'`)
4. Push a la rama (`git push origin feature/NuevaCaracteristica`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.

## 👤 Autor

**Tu Nombre**
- GitHub: [@antonioromdel(https://github.com/antonioromdel)

## 🙏 Agradecimientos

- A la comunidad de Flutter por su excelente documentación
- A todos los contribuidores que ayuden a mejorar este proyecto

---

⭐ Si este proyecto te ha sido útil, considera darle una estrella en GitHub