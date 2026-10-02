import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";

const s3Client = new S3Client({ region: process.env.AWS_REGION });
const BUCKET_NAME = process.env.S3_BUCKET_NAME;

export const handler = async (event) => {
  console.log(`Procesando ${event.Records.length} mensaje(s) de SQS...`);

  for (const record of event.Records) {
    try {
      // 1. Extraer el cuerpo del mensaje enviado por SQS
      const messageBody = record.body;
      
      // Intentar parsear si el contenido viene codificado por API Gateway / VTL
      let parsedData;
      try {
        parsedData = JSON.parse(decodeURIComponent(messageBody));
      } catch {
        parsedData = messageBody; // Si no es JSON o URL-encoded, dejarlo como texto plano
      }

      // 2. Generar una clave única para el objeto en S3
      const timestamp = new Date().toISOString();
      const messageId = record.messageId;
      const s3Key = `eventos/${timestamp.split("T")[0]}/${messageId}.json`;

      // 3. Subir el evento procesado a S3
      const putCommand = new PutObjectCommand({
        Bucket: BUCKET_NAME,
        Key: s3Key,
        Body: JSON.stringify({
          sqsMessageId: messageId,
          receivedAt: timestamp,
          payload: parsedData,
        }, null, 2),
        ContentType: "application/json",
      });

      await s3Client.send(putCommand);
      console.log(`Evento guardado exitosamente en s3://${BUCKET_NAME}/${s3Key}`);

    } catch (error) {
      console.error(`Error procesando el mensaje ${record.messageId}:`, error);
      // Lanzar el error para que SQS reintente o mande el mensaje al DLQ si aplica
      throw error;
    }
  }

  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Procesamiento de SQS completado" }),
  };
};