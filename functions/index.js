const functions = require("firebase-functions");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const nodemailer = require("nodemailer");

// 🔹 Configuración del transporte SMTP de Gmail
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "formularios.darkmattercode@gmail.com", // Cambia esto por tu correo
    pass: "ozqk dicw anbo ccep", // Usa la contraseña de aplicación de Google
  },
});

// 🔹 Función de Firebase para enviar un correo cuando se crea un nuevo formulario en Firestore
exports.sendEmailNotification = onDocumentCreated("formularios/{formId}", (event) => {
  const data = event.data.data(); // Obtener los datos del formulario

  // Configuración del correo
  const mailOptions = {
    from: "formularios.darkmattercode@gmail.com",
    to: "Articmattercode@gmail.com", // Cambia esto por el correo donde recibirás los formularios
    subject: "Nuevo formulario recibido",
    text: `  Nombre: ${data.nombre}
        Email: ${data.email}
        Teléfono: ${data.telefono}
        Empresa: ${data.empresa}
        Servicio: ${data.servicio}
        Tamaño Empresa: ${data.tamaño_empresa}
        Presupuesto: ${data.presupuesto}
        Plazo: ${data.plazo}
        Mensaje: ${data.mensaje}
        Cómo nos encontró: ${data.como_nos_encontro}
        Fecha: ${new Date().toLocaleString()}
      `,
  };

  // 🔹 Enviar el correo
  return transporter.sendMail(mailOptions)
    .then(() => console.log("📧 Correo enviado correctamente"))
    .catch((error) => console.error("❌ Error al enviar correo:", error));
});
