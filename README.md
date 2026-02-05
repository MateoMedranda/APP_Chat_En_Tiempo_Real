# 💬 Chat en Tiempo Real

Bienvenido a **Chat en Tiempo Real**, una aplicación móvil moderna y eficiente diseñada para la comunicación instantánea. Este proyecto demuestra el uso de tecnologías punteras en el ecosistema Flutter, priorizando una arquitectura limpia y escalable.

## ✨ Funcionalidades Principales

*   **Chat en Tiempo Real**: Comunicación fluida y sin latencia utilizando **Firebase Realtime Database**.
*   **Notificaciones Push**: Mantente conectado con alertas instantáneas a través de **Firebase Cloud Messaging**.
*   **Gestión de Estado Robusta**: Implementación reactiva y testable con **Riverpod**.
*   **Diseño Moderno**: Interfaz atractiva con tipografías de **Google Fonts** y un sistema de temas personalizado.
*   **Arquitectura Limpia**: Separación clara de responsabilidades para facilitar el mantenimiento y la escalabilidad.

## 🏗 Arquitectura del Proyecto

Este proyecto sigue los principios de **Clean Architecture** (Arquitectura Limpia), dividiendo el código en capas independientes:

1.  **Domain**: Contiene las Entidades y la lógica de negocio pura. Es el núcleo de la aplicación.
2.  **Data**: Maneja la recuperación de datos (Firebase, APIs locales) e implementa las interfaces del dominio.
3.  **Presentation/UI**: Responsable de mostrar los datos al usuario y manejar las interacciones.

## 📂 Estructura de Directorios

La estructura del código fuente en `lib/` está organizada de la siguiente manera:

```text
lib/
├── data/           # Implementación de repositorios y fuentes de datos
├── domain/         # Entidades del negocio y definiciones de repositorios
├── presentation/   # Lógica de presentación (Notifiers/Controllers)
├── providers/      # Configuración e inyección de dependencias (Riverpod)
├── theme/          # Definiciones de estilos, colores y temas
├── views/          # Pantallas de la aplicación (Pages)
├── widgets/        # Componentes UI reutilizables
├── firebase_options.dart # Configuración autogenerada de Firebase
└── main.dart       # Punto de entrada de la aplicación
```

## 📸 Capturas de Pantalla

_Espacio reservado para mostrar la interfaz de usuario._

| Inicio de Sesión | Lista de Chats | Conversación |
|:---:|:---:|:---:|
| ![Login](/assets/images/login_placeholder.png) | ![Home](/assets/images/home_placeholder.png) | ![Chat](/assets/images/chat_placeholder.png) |
> *Nota: Reemplaza las rutas de arriba con tus capturas reales.*

## 🚀 Guía de Instalación

Sigue estos pasos para ejecutar el proyecto en tu entorno local:

1.  **Clonar el repositorio**
    ```bash
    git clone [URL_DEL_REPOSITORIO]
    cd app_chat_en_tiempo_real
    ```

2.  **Instalar dependencias**
    ```bash
    flutter pub get
    ```

3.  **Configurar Firebase**
    *   Este proyecto utiliza Firebase. Asegúrate de tener los archivos de configuración (`google-services.json` para Android / `GoogleService-Info.plist` para iOS) en sus carpetas correspondientes si no utilizas `flutterfire configure`.

4.  **Ejecutar la aplicación**
    ```bash
    flutter run
    ```

## 🛠 Tecnologías Utilizadas

*   [Flutter](https://flutter.dev/) - Framework UI
*   [Firebase Core, Database & Messaging](https://firebase.google.com/) - Backend as a Service
*   [Riverpod](https://riverpod.dev/) - Gestión de estado
*   [Google Fonts](https://pub.dev/packages/google_fonts) - Tipografía

---
Desarrollado con ❤️ por [Tu Nombre/Equipo]
