exports.handler = async (event) => {
    console.log("Evento recibido de SQS:", JSON.stringify(event, null, 2));

    // Iterar sobre los mensajes del lote enviado por SQS
    for (const record of event.Records) {
        const body = record.body;
        console.log("Procesando mensaje SQS:", body);
        
        // Aquí luego agregaremos la lógica para guardar el objeto en S3
    }

    return {
        statusCode: 200,
        body: JSON.stringify({ message: "Mensajes procesados exitosamente" })
    };
};