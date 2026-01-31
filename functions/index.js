const { onValueCreated } = require("firebase-functions/v2/database");
const admin = require("firebase-admin");

admin.initializeApp();

// Cloud Function que se dispara cuando se crea un nuevo mensaje
exports.enviarNotificacion = onValueCreated(
  {
    ref: "/chats/{chatPath}/{messageId}"
  },
  async (event) => {
    const mensaje = event.data.val();
    const chatPath = event.params.chatPath;
    
    // chatPath es algo como: "usuario1_usuario2"
    const usuarios = chatPath.split('_');
    const autor = mensaje.autor;
    const receptor = usuarios.find(u => u !== autor);
    
    if (!receptor) {
      console.log('No se encontró receptor');
      return;
    }
    
    console.log(`Enviando notificación a ${receptor} sobre mensaje de ${autor}`);
    
    try {
      // Obtener token del receptor
      const userSnapshot = await admin.database().ref(`usuarios/${receptor}`).get();
      const token = userSnapshot.val()?.fcm_token;
      
      if (!token) {
        console.log(`No hay token FCM para ${receptor}`);
        return;
      }
      
      console.log(`Token encontrado para ${receptor}: ${token.substring(0, 20)}...`);
      
      // Enviar notificación push
      const message = {
        notification: {
          title: `Mensaje de ${autor}`,
          body: mensaje.texto.substring(0, 100), // Limitar a 100 caracteres
        },
        data: {
          autor: autor,
          chatPath: chatPath,
          timestamp: Date.now().toString(),
        },
        token: token,
      };
      
      const response = await admin.messaging().send(message);
      console.log('Notificación enviada exitosamente:', response);
    } catch (error) {
      console.error('Error enviando notificación:', error);
    }
  }
);
